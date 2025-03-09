//go:build ggml
// +build ggml

package ollamarunner

import (
	"github.com/ollama/ollama/llm"
	_ "github.com/ollama/ollama/llm/backend/ggml"
)

// DType 定义了张量数据类型
type DType = llm.DType

// 定义数据类型常量
const (
	DTypeF16 DType = llm.DTypeF16
	DTypeQ40 DType = llm.DTypeQ40
	DTypeQ80 DType = llm.DTypeQ80
)

// Input 定义了模型输入的结构
type Input = llm.Input
