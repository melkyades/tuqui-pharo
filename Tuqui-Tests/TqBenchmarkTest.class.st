Class {
	#name : #TqBenchmarkTest,
	#superclass : #TuquiTest,
	#category : #'Tuqui-Tests'
}

{ #category : #accessing }
TqBenchmarkTest class >> defaultTimeLimit [
	^ 1000 seconds
]

{ #category : #tests }
TqBenchmarkTest >> bench: aBlock named: name [

	self bench: aBlock named: name times: 10
]

{ #category : #tests }
TqBenchmarkTest >> bench: aBlock named: name times: n [

	| times |
	Transcript
		nextPutAll: 'benchmarking ';
		nextPutAll: name;
		space;
		print: n;
		nextPutAll: 'times...';
		flush.
	times := (1 to: n) collect: [ :i |
		         aBlock timeToRun nanoSeconds / 1000000.0 ].
	Transcript
		nextPutAll: ' done!';
		cr;
		nextPutAll: 'bench times (in ms) were: ';
		cr;
		print: times;
		nextPutAll: '(total:';
		print: times sum;
		nextPutAll: 'ms)';
		cr;
		nextPutAll: 'mean per iteration: ';
		print: times average;
		nextPutAll: 'ms; median per iteration: ';
		print: times median;
		nextPutAll: 'ms';
		cr;
		flush
]

{ #category : #tests }
TqBenchmarkTest >> test400benchmarkBounce [

	self
		compile: 'bench | result | Bounce new innerBenchmarkLoop: 10'
		in: #ProtoObject
		during: [
			self
				bench: [ runtime sendLocal: #bench to: runtime true ]
				named: 'Bounce' ]
]

{ #category : #tests }
TqBenchmarkTest >> test401benchmarkList [

	self
		compile: 'bench | result | AWFYList new innerBenchmarkLoop: 10'
		in: #ProtoObject
		during: [
			self
				bench: [ runtime sendLocal: #bench to: runtime true ]
				named: 'List' ]
]

{ #category : #tests }
TqBenchmarkTest >> test402benchmarkPermute [

	self
		compile: 'bench | result | Permute new innerBenchmarkLoop: 10'
		in: #ProtoObject
		during: [
			self
				bench: [ runtime sendLocal: #bench to: runtime true ]
				named: 'Permute' ]
]

{ #category : #tests }
TqBenchmarkTest >> test403benchmarkQueens [

	self
		compile: 'bench | result | Queens new innerBenchmarkLoop: 10'
		in: #ProtoObject
		during: [
			self
				bench: [ runtime sendLocal: #bench to: runtime true ]
				named: 'Queens' ]
]

{ #category : #tests }
TqBenchmarkTest >> test404benchmarkSieve [

	self
		compile: 'bench | result | Sieve new innerBenchmarkLoop: 10'
		in: #ProtoObject
		during: [
			self
				bench: [ runtime sendLocal: #bench to: runtime true ]
				named: 'Sieve' ]
]

{ #category : #tests }
TqBenchmarkTest >> test405benchmarkStorage [

	self
		compile: 'bench | result | Storage new innerBenchmarkLoop: 10'
		in: #ProtoObject
		during: [
			self
				bench: [ runtime sendLocal: #bench to: runtime true ]
				named: 'Storage' ]
]

{ #category : #tests }
TqBenchmarkTest >> test406benchmarkTowers [

	self
		compile: 'bench | result | Towers new innerBenchmarkLoop: 10'
		in: #ProtoObject
		during: [
			self
				bench: [ runtime sendLocal: #bench to: runtime true ]
				named: 'Towers' ]
]

{ #category : #tests }
TqBenchmarkTest >> test500benchmarkCD [

	self
		compile: 'bench | result | CD new innerBenchmarkLoop: 10'
		in: #ProtoObject
		during: [
			self
				bench: [ runtime sendLocal: #bench to: runtime true ]
				named: 'CD' ]
]

{ #category : #tests }
TqBenchmarkTest >> test501benchmarkDeltaBlue [

	self
		compile: 'bench | result | DeltaBlue new innerBenchmarkLoop: 10'
		in: #ProtoObject
		during: [
			self
				bench: [ runtime sendLocal: #bench to: runtime true ]
				named: 'DeltaBlue' ]
]

{ #category : #tests }
TqBenchmarkTest >> test502benchmarkRichards [

	self
		compile: 'bench | result | Richards new innerBenchmarkLoop: 10'
		in: #ProtoObject
		during: [
			self
				bench: [ runtime sendLocal: #bench to: runtime true ]
				named: 'Richards' ]
]

{ #category : #tests }
TqBenchmarkTest >> test503benchmarkHavlak [

	self
		compile: 'bench | result | Havlak new innerBenchmarkLoop: 10'
		in: #ProtoObject
		during: [
			self
				bench: [ runtime sendLocal: #bench to: runtime true ]
				named: 'Havlak' ]
]
