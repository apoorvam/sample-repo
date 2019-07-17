package main

import "testing"

func TestSample(t *testing.T) {
	if 1 != 1 {
		t.Error("test sample not as expected")
	}
}

