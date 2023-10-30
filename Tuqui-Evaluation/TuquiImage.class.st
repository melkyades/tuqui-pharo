"
I'm in charge of creating and managing the objects of an image. I'm created from a spec,
and I know how to bootstrap and connect an initial graph of objects and classes.

I do not add the spec methods to classes, as it requires some emulation done by
the `VirtualRuntime`. That step is left to the `VirtualImage`
that also creates the Kernel module.
"
Class {
	#name : #TuquiImage,
	#superclass : #Object,
	#instVars : [
		'nilObj',
		'falseObj',
		'trueObj',
		'wordSize',
		'maxSMI',
		'minSMI',
		'symbols',
		'globals'
	],
	#classVars : [
		'KernelSpec',
		'LMRBootstrapperSpec',
		'VMPrimitivesSpec'
	],
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #initialization }
TuquiImage >> basicNewArrayedSlotsSized: anInteger [

	| header result |
	header := TqObjectHeader new
		          bytes: false arrayed: true named: false;
		          size: anInteger;
		          hash: 0.
	result := TqSlotObject new.
	^ result
		  header: header;
		  nilSlots: nilObj
]

{ #category : #initialization }
TuquiImage >> basicNewArrayedSlotsSized: anInteger named: aBoolean [

	| header result |
	header := TqObjectHeader new
		          bytes: false arrayed: true named: aBoolean;
		          size: anInteger;
		          hash: 0.
	result := TqSlotObject new.
	^ result
		  header: header;
		  nilSlots: nilObj
]

{ #category : #initialization }
TuquiImage >> basicNewBehavior: instSize [

	| header behavior |
	header := TqObjectHeader new
		          bytes: false arrayed: false named: true;
		          size: instSize;
		          hash: 0.
	behavior := TqBehaviorObject new.
	^ behavior
			runtime: self;
		  header: header;
		  nilSlots: nilObj
]

{ #category : #initialization }
TuquiImage >> basicNewBytesSized: anInteger [

	| header result |
	header := TqObjectHeader new
		          bytes: true arrayed: true named: false;
		          size: anInteger;
		          hash: 0.
	result := TqByteObject new.
	^ result header: header
]

{ #category : #initialization }
TuquiImage >> basicNewBytesWith: aByteObject [

	| header result |
	header := TqObjectHeader new
		          bytes: true arrayed: true named: false;
		          size: aByteObject size;
		          hash: 0.
	result := TqByteObject new.
	^ result
		  header: header;
		  loadFrom: aByteObject
]

{ #category : #initialization }
TuquiImage >> basicNewSlots: type sized: anInteger [
	| header result |
	header := TqObjectHeader new
		bytes: false arrayed: false named: true;
		size: anInteger;
		hash: 0.
	result := type new.
	^ result
		header: header;
		nilSlots: nilObj
]

{ #category : #initialization }
TuquiImage >> basicNewSlotsSized: anInteger [
	^self basicNewSlots: TqSlotObject sized: anInteger
]

{ #category : #accessing }
TuquiImage >> false [
	^ falseObj
]

{ #category : #initialization }
TuquiImage >> globals [

^	globals 
]

{ #category : #initialization }
TuquiImage >> globals: aTqVMDictionary [
	globals := aTqVMDictionary
]

{ #category : #initialization }
TuquiImage >> initialize [

	nilObj := self basicNewSlotsSized: 0.
	trueObj := self basicNewSlotsSized: 0.
	falseObj := self basicNewSlotsSized: 0.

]

{ #category : #accessing }
TuquiImage >> maxSMI [

	^ maxSMI
]

{ #category : #accessing }
TuquiImage >> minSMI [

	^ minSMI
]

{ #category : #initialization }
TuquiImage >> newArrayedSlots: behavior size: anInteger named: aBoolean [

	| result |
	result := self basicNewArrayedSlotsSized: anInteger named: aBoolean.
	^ result
		  behavior: behavior
]

{ #category : #initialization }
TuquiImage >> newBytes: behavior contents: aByteObject [

	| result |
	result := self basicNewBytesWith: aByteObject.
	^ result behavior: behavior
]

{ #category : #initialization }
TuquiImage >> newBytes: behavior size: anInteger [

	| result |
	result := self basicNewBytesSized: anInteger.
	^ result behavior: behavior
]

{ #category : #initialization }
TuquiImage >> newSlots: class [
	^self newSlots: class size: 0
]

{ #category : #initialization }
TuquiImage >> newSlots: behavior size: anInteger [

	| result |
	result := self basicNewSlotsSized: anInteger.
	^ result behavior: behavior
]

{ #category : #initialization }
TuquiImage >> newVMDictionary: behavior size: anInteger [

	| result |
	result := self basicNewSlots: TqVMDictionary sized: anInteger.
	^ result behavior: behavior; runtime: self
]

{ #category : #accessing }
TuquiImage >> nil [
	^ nilObj
]

{ #category : #accessing }
TuquiImage >> symbols: aTqSymbolSet [
	symbols := aTqSymbolSet
]

{ #category : #accessing }
TuquiImage >> true [
	^ trueObj
]

{ #category : #accessing }
TuquiImage >> wordSize [
	^ wordSize
]

{ #category : #accessing }
TuquiImage >> wordSize: anInteger [
	wordSize := anInteger.
	maxSMI := (1 bitShift: wordSize * 8 - 2) - 1.
	minSMI := maxSMI negated - 1

]
