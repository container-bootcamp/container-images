module Fluent

    class NewKubernetesDockerTailInput < NewTailInput
        Plugin.register_input("kubernetes_docker_tail", self)

        desc 'The file to read the container name'
        config_param :container_name_file, :string

        def initialize
            super
        end

        def setup_watcher(path, pe)
            line_buffer_timer_flusher = (@multiline_mode && @multiline_flush_interval) ? TailWatcher::LineBufferTimerFlusher.new(log, @multiline_flush_interval, &method(:flush_buffer)) : nil
            tw = DockerTailWatcher.new(path, @container_name_file, @rotate_wait, pe, log, @read_from_head, @enable_watch_timer, @read_lines_limit, method(:update_watcher), line_buffer_timer_flusher,  &method(:receive_lines))
            tw.attach(@loop)
            tw
        end

        class DockerTailWatcher < TailWatcher
            def initialize(path, container_name_file, rotate_wait, pe, log, read_from_head, enable_watch_timer, read_lines_limit, update_watcher, line_buffer_timer_flusher, &receive_lines)
                super(path, rotate_wait, pe, log, read_from_head, enable_watch_timer, read_lines_limit, update_watcher, line_buffer_timer_flusher, &receive_lines)

                filename = File.join(File.dirname(path), container_name_file)
            
                if File.exist?(filename)
                    parsed = JSON.parse(IO.read(filename))
                    @container_name = parsed["Config"]["Labels"]["io.kubernetes.pod.namespace"] + 
                                    '.' + parsed["Config"]["Labels"]["io.kubernetes.pod.name"]
                else
                    @container_name = File.dirname(path).split('/').last
                end
            end

            def tag
                @parsed_tag ||= @container_name
            end
        end
    end
end