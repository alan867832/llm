//go:build ggml

package ollamarunner

import (
	"github.com/ollama/ollama/ml"
	_ "github.com/ollama/ollama/ml/backend/ggml"
	"github.com/ollama/ollama/model"
)

// Ensure types are available
type (
	DType = ml.DType
	Input = model.Input
)

const (
	DTypeQ80 DType = ml.DTypeQ80
	DTypeQ40 DType = ml.DTypeQ40
	DTypeF16 DType = ml.DTypeF16
)
