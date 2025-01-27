package main

import (
	"fmt"
)

func Map[T any](list []T, fn func(T) T) []T {
	if len(list) == 0 {
		return list
	}
	return append([]T{fn(list[0])}, Map(list[1:], fn)...)
}

func main() {
	num_list := []uint8{1, 5, 12, 65, 2, 14}
	r_num_list := Map(num_list, func(x uint8) uint8 { return x * 2 })
	fmt.Println(r_num_list)

	str_list := []string{"poggers", "pog", "test", "jsp si ça marche"}
	r_str_list := Map(str_list, func(x string) string { return x + "XD" })
	fmt.Println(r_str_list)
	return
}
