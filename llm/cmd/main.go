package main

import (
	"errors"
	"fmt"
	"llm/runner"
	"os"

	"github.com/ollama/ollama/ml"
	"github.com/ollama/ollama/model"
)

func main() {
	model.Register("qwen2", NewQwen2Model)
	if err := runner.Execute(os.Args[1:]); err != nil {
		fmt.Fprintf(os.Stderr, "error: %s\n", err)
		os.Exit(1)
	}
}

func NewQwen2Model(config ml.Config) (model.Model, error) {
	return nil, errors.New("not implemented")
}
