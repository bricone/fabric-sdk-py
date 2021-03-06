define run-py-tox
	@echo "run python tox $@"
	# set -o pipefail
	rm -rf .tox/$@/log
	# bin_path=.tox/$@/bin
	# export PYTHON=$bin_path/python
	tox -v -e$@ -- test
	# set +o pipefail
endef

# Triggered by the ci
check:
	bash check.sh

# Run all unit test cases
unittest: cov-init pylint flake8 py27 py35 cov-report

cov-init:
	$(call run-py-tox)

pylint:
	$(call run-py-tox)

py27:
	$(call run-py-tox)

py30:
	$(call run-py-tox)

py35:
	$(call run-py-tox)

flake8:
	$(call run-py-tox)

cov-report:
	$(call run-py-tox)

# Generate the hyperledger/fabric-sdk-py image
.PHONY: image
image:
	docker build -t hyperledger/fabric-sdk-py .

# Generate the protobuf python files
.PHONY: proto
proto:
	python3 -m grpc.tools.protoc \
		-I./\
		--python_out=./ \
		--grpc_python_out=./ \
		hfc/protos/**/*.proto

# Clean temporary files
.PHONY: clean
clean:
	rm -rf .cache *.egg-info .tox
	find . -name "*.pyc" -exec rm -rf "{}" \;
