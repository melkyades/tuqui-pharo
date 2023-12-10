Class {
	#name : #TuquiTest,
	#superclass : #TestCase,
	#instVars : [
		'runtime',
		'bootstrapper'
	],
	#category : #'Tuqui-Tests'
}

{ #category : #tests }
TuquiTest >> ==> anObject [
	| class |
	class := anObject class.
	anObject isInteger
		ifTrue: [ ^ runtime newInteger: anObject ].
	anObject == nil
		ifTrue: [ ^ runtime nil ].
	anObject == false
		ifTrue: [ ^ runtime false ].
	anObject == true
		ifTrue: [ ^ runtime true ].
	(class == Symbol or: [ class inheritsFrom: Symbol ])
		ifTrue: [ ^ runtime symbolFromLocal: anObject ].
	anObject isString
		ifTrue: [ ^ runtime newString: anObject ].
	class = ByteArray
		ifTrue: [ ^ runtime newBytesFrom: anObject ].
	self ASSERT: false
]

{ #category : #tests }
TuquiTest >> assertNoLeftoverFrames [
	self assert: runtime currentEvaluator hasFinished
]

{ #category : #tests }
TuquiTest >> compile: aString in: classname during: aBlock [

	| class behavior md selector method |
	class := self globalNamed: classname.
	behavior := runtime speciesInstanceBehavior: class.
	md := runtime behaviorMethodDictionary: behavior.
	method := SCompiler new compile: aString.
	self assert: method notNil.
	method := bootstrapper transferMethod: method in: class.
	selector := method slotAt: 5.
	runtime sendLocal: #at:put: to: md with: {
			selector.
			method }.
	aBlock value
]

{ #category : #tests }
TuquiTest >> convert: anObject with: map [
	map at: anObject ifPresent: [:mapped | ^mapped ].
	anObject ifNil: [ ^runtime nil ].
	anObject isInteger
		ifTrue: [ ^ runtime newInteger: anObject ].
	anObject isSymbol
		ifTrue: [ ^ runtime addSymbol: anObject ].
	anObject isString
		ifTrue: [ ^ runtime newString: anObject ].
	anObject class = ByteArray
		ifTrue: [ ^ runtime newByteArray: anObject ].
	anObject class = SCompiledBlock ifTrue: [ ^self convertBlock: anObject with: map ].
	self ASSERT: false
]

{ #category : #tests }
TuquiTest >> convertBlock: anSCompiledBlock with: map [
	| class result instsize slot |
	class := self globalNamed: #CompiledBlock.
	result := runtime newSlots: class size: 0.
	map at: anSCompiledBlock put: result.
	instsize := anSCompiledBlock class instSize.
	1 to: instsize do: [ :i | 
		slot := anSCompiledBlock instVarAt: i.
		result slotAt: i put: (self convert: slot with: map) ].
	^ result
]

{ #category : #tests }
TuquiTest >> convertMethod: anSCompiledMethod [
	| class |
	
	class := bootstrapper classNamed: anSCompiledMethod classBinding name.
	^bootstrapper transferMethod: anSCompiledMethod in: class 
]

{ #category : #tests }
TuquiTest >> globalNamed: aSymbol [
	^bootstrapper classNamed: aSymbol
]

{ #category : #running }
TuquiTest >> setUp [

	bootstrapper := TuquiRingBootstrapper new.
	runtime := bootstrapper genesis image.
	runtime useLinkedIterativeEvaluator
]
