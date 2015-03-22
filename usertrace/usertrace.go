package usertrace

import (
	"fmt"
	"os"
	"runtime"
)

type TraceEntry struct {
	Category  string  `json:"cat"`
	Name      string  `json:"name"`
	Pid       int     `json:"pid"`
	Tid       string  `json:"tid"`
	Timestamp float64 `json:"ts"`
	Phase     string  `json:"ph"`
}

var pid = os.Getpid()
var StartTime = nowNano()
var TraceEntries []TraceEntry

func now() (sec int64, nsec int32)

func nowNano() int64 {
	sec, nsec := now()
	return sec*1000000000 + int64(nsec)
}

func Now() float64 {
	return float64(nowNano()-StartTime) / 1000
}

func TraceBegin(name string) {
	g := fmt.Sprintf("go %#x", runtime.G())
	TraceEntries = append(TraceEntries, TraceEntry{
		Category:  "go",
		Name:      name,
		Pid:       pid,
		Tid:       g,
		Timestamp: Now(),
		Phase:     "B",
	})
}

func TraceEnd() {
	g := fmt.Sprintf("go %#x", runtime.G())
	TraceEntries = append(TraceEntries, TraceEntry{
		Category:  "go",
		Pid:       pid,
		Tid:       g,
		Timestamp: Now(),
		Phase:     "E",
	})
}

func TraceCall(name string) func() {
	TraceBegin(name)
	return TraceEnd
}
