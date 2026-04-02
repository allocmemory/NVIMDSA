local log = require("leetcode.logger")

---@class lc.learn.Runner
local runner = {}

-- Tracks whether a run is currently in progress to prevent overlapping jobs.
local running = false

---Write lines to a file, appending the test harness, then execute asynchronously.
---
---@param module_name string  used to name the temp file
---@param exercise table      the exercise table from the data file (needs .ext, .tests)
---@param buf_lines string[]  current lines of the right (code) buffer
---@param callback fun(output: string[])  called on the main thread with result lines
function runner.run(module_name, exercise, buf_lines, callback)
    if running then
        log.warn("A test run is already in progress")
        return
    end

    local tmp_path = ("/tmp/leet_learn_%s.%s"):format(module_name, exercise.ext)

    -- Write buffer contents + test harness to temp file.
    local f, err = io.open(tmp_path, "w")
    if not f then
        log.error("learn runner: could not open temp file: " .. (err or "unknown error"))
        return
    end

    f:write(table.concat(buf_lines, "\n"))
    f:write("\n")
    f:write(exercise.tests)
    f:close()

    local interpreter = ({
        python = "python3",
        py = "python3",
        ts = "bun",
        typescript = "bun",
        javascript = "node",
        js = "node",
    })[exercise.ext] or "python3"

    running = true
    local output_chunks = {}

    vim.fn.jobstart({ interpreter, tmp_path }, {
        stdout_buffered = true,
        stderr_buffered = true,

        on_stdout = function(_, data, _)
            if data then
                for _, line in ipairs(data) do
                    -- jobstart gives an empty string as the last chunk sentinel; skip it.
                    if line ~= "" then
                        table.insert(output_chunks, line)
                    end
                end
            end
        end,

        on_stderr = function(_, data, _)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        table.insert(output_chunks, line)
                    end
                end
            end
        end,

        on_exit = function(_, exit_code, _)
            running = false

            vim.schedule(function()
                if vim.tbl_isempty(output_chunks) then
                    if exit_code ~= 0 then
                        output_chunks = { "Error: process exited with code " .. exit_code }
                    else
                        output_chunks = { "(no output)" }
                    end
                end

                table.insert(output_chunks, "")
                table.insert(output_chunks, "press q to close")
                callback(output_chunks)
            end)
        end,
    })
end

return runner
