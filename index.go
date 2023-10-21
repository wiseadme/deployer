package main

import (
    "fmt"
    "net/http"
    "os"
)

func main() {
    portStr := os.Getenv("PORT")
    http.Handle("/deploy", hwHandler{})
    http.ListenAndServe(":"+portStr, nil)
}

type hwHandler struct{}

func (hwHandler) ServeHTTP(writer http.ResponseWriter, request *http.Request) {
		// get user and host from environment
		sshUser := os.Getenv("SSH_USER")
		sshHost := os.Getenv("SSH_HOST")
		// run ssh an ssh command using user and host
		cmd := exec.Command("./deploy", sshUser, sshHost)
		_, err := cmd.StdoutPipe()

		err = cmd.Start()
		if err != nil {
				fmt.Fprintln(os.Stderr, "Error", err)
				return
		}

		err = cmd.Wait()
		if err != nil {
				fmt.Fprintln(os.Stderr, "Error", err)
				return
		}

		writer.WriteHeader(200)
}