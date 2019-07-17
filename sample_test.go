package main

import "testing"

func TestSample(t *testing.T) {
	got := "foo"
	want := "foo"
	if got != want {
		t.Error("test sample not as expected")
	}
}

