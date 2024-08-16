defmodule TodoList do
  @tasks_file "out.txt"

  def start() do   
    get_tasks() |> handle_command()
  end

  defp get_tasks() do
    case File.read(@tasks_file) do
      {:ok, content} ->
        String.split(content, "\n", trim: true)
      {:error, reason} ->
        IO.puts("Failed to read the file: #{reason}")
        []
    end
  end

  defp add_task(tasks) do
    tasks = tasks ++ [String.trim(IO.gets("Enter the task to add: "))]
    File.write!(@tasks_file, Enum.join(tasks, "\n"))
    handle_command(tasks)
  end

  defp delete_task(tasks) do
    Enum.each(Enum.with_index(tasks), fn {task, index} -> IO.puts("#{index} - #{task}") end)
    case Integer.parse(String.trim(IO.gets("Enter the number of the task to delete: "))) do
      {index, ""} when index >= 0 and index < length(tasks) ->
        tasks = List.delete_at(tasks, index)
        File.write!(@tasks_file, Enum.join(tasks, "\n"))
        handle_command(tasks)
      _ ->
        IO.puts("Invalid task number.")
        handle_command(tasks)
    end
  end
  
  defp handle_command(tasks) do
    case String.trim(IO.gets("What would you like to do? (add/list/delete/quit): ")) do
      "add" ->
        add_task(tasks)
      "list" ->
        Enum.each(tasks, fn task -> IO.puts("- #{task}") end)
        handle_command(tasks)
      "delete" ->
        delete_task(tasks)
      "quit" ->
        IO.puts("Goodbye!")
      _ ->
        IO.puts("Invalid command.")
        handle_command(tasks)
      end
  end

end
TodoList.start()
