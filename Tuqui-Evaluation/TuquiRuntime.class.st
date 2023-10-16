Class {
	#name : #TuquiRuntime,
	#superclass : #TuquiImage,
	#instVars : [
		'behaviorNextIndex',
		'behaviorMethodDictionaryIndex',
		'behaviorClassIndex',
		'classModuleIndex',
		'classNameIndex',
		'closureBlockIndex',
		'dictionaryTableIndex',
		'metaclassInstanceClassIndex',
		'methodAstcodesIndex',
		'methodClassBindingIndex',
		'methodExecutableCodeIndex',
		'methodFlagsIndex',
		'methodSelectorIndex',
		'speciesInstanceBehaviorIndex',
		'speciesFormatIndex',
		'speciesSuperclassIndex',
		'speciesIvarsIndex',
		'metaclassClass',
		'smallIntegerClass'
	],
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #accessing }
TuquiRuntime >> behaviorClass: aTqObject [
	^ aTqObject slotAt: behaviorClassIndex
]

{ #category : #accessing }
TuquiRuntime >> behaviorOf: aTqObject [
	^aTqObject isImmediate ifTrue: [ self smallIntegerBehavior ] ifFalse: [aTqObject behavior]
]

{ #category : #accessing }
TuquiRuntime >> className: aTqObject [
	^ aTqObject slotAt: classNameIndex
]

{ #category : #accessing }
TuquiRuntime >> initializeFrom: bootstrapper [
	
	  behaviorNextIndex := (bootstrapper => #Behavior) allInstVarNames indexOf: 'next'.
    behaviorMethodDictionaryIndex := (bootstrapper => #Behavior) allInstVarNames indexOf: 'methods'.
    behaviorClassIndex := (bootstrapper => #Behavior) allInstVarNames indexOf: 'class'.
    classNameIndex := (bootstrapper => #Class) allInstVarNames indexOf: 'name'.
    closureBlockIndex := (bootstrapper => #Closure) allInstVarNames indexOf: 'block'.
    metaclassInstanceClassIndex := (bootstrapper => #Metaclass) allInstVarNames indexOf: 'class'.
    methodAstcodesIndex := (bootstrapper => #CompiledMethod) allInstVarNames indexOf: 'treecodes'.
    methodClassBindingIndex := (bootstrapper => #CompiledMethod) allInstVarNames indexOf: 'class'.
    methodExecutableCodeIndex := (bootstrapper => #CompiledMethod) allInstVarNames indexOf: 'executableCode'.
    methodFlagsIndex := (bootstrapper => #CompiledMethod) allInstVarNames indexOf: 'flags'.
    methodSelectorIndex := (bootstrapper => #CompiledMethod) allInstVarNames indexOf: 'selector'.
    speciesInstanceBehaviorIndex := (bootstrapper => #Species) allInstVarNames indexOf: 'instanceBehavior'.
    speciesFormatIndex := (bootstrapper => #Species) allInstVarNames indexOf: 'format'.
    speciesSuperclassIndex := (bootstrapper => #Species) allInstVarNames indexOf: 'superclass'.
    speciesIvarsIndex := (bootstrapper => #Species) allInstVarNames indexOf: 'instanceVariables'.
		metaclassClass := bootstrapper classNamed: #Metaclass.
		smallIntegerClass := bootstrapper classNamed: #SmallInteger

]

{ #category : #accessing }
TuquiRuntime >> isMetaclass: aTqObject [
	^ (self speciesFor: aTqObject) == metaclassClass
]

{ #category : #accessing }
TuquiRuntime >> metaclassInstanceClass: aTqObject [
	^ aTqObject slotAt: metaclassInstanceClassIndex
]

{ #category : #accessing }
TuquiRuntime >> print: aTqObject on: aStream [

	| species name selector |
	species := self behaviorClass: aTqObject behavior.
	name := self speciesLocalName: species.
	name = 'Symbol' ifTrue: [
		^ aStream nextPutAll: '<#' , aTqObject asLocalString , '>' ].
	name = 'String' ifTrue: [
		^ aStream nextPutAll: '<''' , aTqObject asLocalString , '''>' ].
	name = 'CompiledMethod' ifTrue: [
		selector := aTqObject slotAt: methodSelectorIndex.
		selector := selector == nilObj
			            ifTrue: [ '<nil>' ]
			            ifFalse: [ selector asLocalString ].
		^ aStream
			  nextPutAll: '<';
			  print: (self methodClassBinding: aTqObject);
			  nextPutAll: '>>#';
			  nextPutAll: selector;
			  nextPutAll: '>' ].
	aStream
		nextPut: $<;
		nextPutAll: name withArticle;
		nextPut: $>

]

{ #category : #accessing }
TuquiRuntime >> printBehavior: aTqBehavior on: aStream [
	| species name |
	species := self behaviorClass: aTqBehavior.
	name := self speciesLocalName: species.
	aStream
		nextPutAll: '<' , name , ' instanceBehavior>'
]

{ #category : #accessing }
TuquiRuntime >> smallIntegerBehavior [
	^self speciesInstanceBehavior: smallIntegerClass
]

{ #category : #accessing }
TuquiRuntime >> speciesFor: aTqObject [
	| behavior |
	behavior := self behaviorOf: aTqObject.
	^self behaviorClass: behavior.


]

{ #category : #accessing }
TuquiRuntime >> speciesInstanceBehavior: aTqObject [
	^aTqObject slotAt: speciesInstanceBehaviorIndex
]

{ #category : #accessing }
TuquiRuntime >> speciesLocalName: species [
	| name class |
	(self isMetaclass: species) ifFalse: [
		name := self className: species.
		^name asLocalString].
	
	class := self metaclassInstanceClass: species. 
	name := self className: class.
	^ name asLocalString, ' class'
]
