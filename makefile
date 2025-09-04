CC = gcc
CFLAGS = -Wall -g
TARGET = calculadora

# Define o diretório de build e os arquivos objeto
BUILD_DIR = build
OBJECTS = $(BUILD_DIR)/calculadora.o $(BUILD_DIR)/calculadora.tab.o $(BUILD_DIR)/lex.yy.o

# Arquivos gerados pelo Flex/Bison
BISON_C = $(BUILD_DIR)/calculadora.tab.c
BISON_H = $(BUILD_DIR)/calculadora.tab.h
FLEX_C = $(BUILD_DIR)/lex.yy.c

all: $(TARGET)

# Regra de linkagem: cria o executável a partir dos objetos no diretório de build
$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJECTS)

# Regra para criar o diretório de build antes de qualquer outra coisa
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Regras de compilação para os arquivos .o, colocando-os no BUILD_DIR
$(BUILD_DIR)/calculadora.o: calculadora.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/calculadora.tab.o: $(BISON_C) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/lex.yy.o: $(FLEX_C) $(BISON_H) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Regras para gerar os arquivos do Bison no BUILD_DIR
$(BISON_C) $(BISON_H): calculadora.y | $(BUILD_DIR)
	bison -d calculadora.y --output=$(BISON_C) --defines=$(BISON_H)

# Regra para gerar o arquivo do Flex no BUILD_DIR
$(FLEX_C): calculadora.l | $(BUILD_DIR)
	flex -o $(FLEX_C) calculadora.l

run: all
	./$(TARGET) in.txt

# Limpa o executável e o diretório de build inteiro
clean:
	rm -f $(TARGET)
	rm -rf $(BUILD_DIR)