BUILD_DIR := .build
TARGET := v12n-cli

.PHONY : all
all : $(TARGET)

.PHONY : $(TARGET)
$(TARGET) : src/*.swift
	mkdir -p $(BUILD_DIR)
	swiftc $^ -o $(BUILD_DIR)/$@

.PHONY : clean
clean :
	rm -rf $(BUILD_DIR)
