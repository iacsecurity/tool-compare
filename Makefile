
default: run-all

.PHONY: run-%
run-%:
	@echo "Running $*"
	./run_all_tools.sh run_$*

.PHONY: run-all
run-all:
	@echo "Running all tools"
	./run_all_tools.sh

.PHONY: clear-%-results
clear-%-results:
	@echo "Clearing results for $*"
	find . -name "$*_results.txt" -print -delete;

.PHONY: clear-all-results
clear-all-results:
	@echo "Clearing all results"
	find . -name "*_results.txt" -print -delete

.PHONY: clear-plans
clear-plans:
	@echo "Clearing all results"
	find . -name "plan.out" -print -delete;

.PHONY: generate-readme
generate-readme:
	@python3 generate_readme_tables.py > README.md