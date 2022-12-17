package main

import (
	"github.com/fsnotify/fsnotify"
	"log"
	"os"
)

func main() {
	if len(os.Args) <= 1 {
		log.Println("请输入需要监控的文件夹路径!!")
		log.Println("如: ./FileMonitor /data/local/tmp")
		return
	}
	watch, err := fsnotify.NewWatcher()
	if err != nil {
		log.Fatal(err)
	}
	defer watch.Close()
	err = watch.Add(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	go func() {
		for {
			select {
			case ev := <-watch.Events:
				{
					if ev.Op&fsnotify.Create == fsnotify.Create {
						log.Println("创建: ", ev.Name)
					}
					if ev.Op&fsnotify.Write == fsnotify.Write {
						log.Println("写入: ", ev.Name)
					}
					if ev.Op&fsnotify.Remove == fsnotify.Remove {
						log.Println("删除: ", ev.Name)
					}
					if ev.Op&fsnotify.Rename == fsnotify.Rename {
						log.Println("重命名: ", ev.Name)
					}
					if ev.Op&fsnotify.Chmod == fsnotify.Chmod {
						log.Println("修改权限: ", ev.Name)
					}
				}
			case err := <-watch.Errors:
				{
					log.Println("error : ", err)
					return
				}
			}
		}
	}()
	select {}
}
