Class {
	#name : #TqEvaluationContext,
	#superclass : #Object,
	#instVars : [
		'runtime'
	],
	#pools : [
		'ClosureElementTypes'
	],
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #visiting }
TqEvaluationContext >> argumentAt: anInteger [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> argumentAt: anInteger in: environmentIndex [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> arguments [
	^ self subclassResponsibility
]

{ #category : #services }
TqEvaluationContext >> backtrace [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> captureClosure: anSBlock [
	| closure s i type env arg |
	closure := runtime newClosureFor: anSBlock compiledCode.
	s := anSBlock capturedVariables readStream.
	i := 1.
	[ s atEnd ]
		whileFalse: [ type := s next.
			type = Self
				ifTrue: [ closure at: i put: self self ].
			type = Environment
				ifTrue: [ closure at: i put: self environment ].
			type = EnvironmentValue
				ifTrue: [ env := self environment at: s next.
					closure at: i put: env ].
			type = LocalArgument
				ifTrue: [ arg := self argumentAt: s next.
					closure at: i put: arg ].
			i := i + 1 ].
	^ closure
]

{ #category : #services }
TqEvaluationContext >> classBinding [
	^runtime methodClassBinding: self method
]

{ #category : #visiting }
TqEvaluationContext >> environment [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> false [
	^ runtime false
]

{ #category : #visiting }
TqEvaluationContext >> firstArgument [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> fourthArgument [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> instanceVarAt: index [
	^ runtime instanceVarOf: self self at: index
]

{ #category : #visiting }
TqEvaluationContext >> instanceVarAt: index put: value [
	^ runtime instanceVarOf: self self at: index put: value
]

{ #category : #services }
TqEvaluationContext >> loadAssociationValue: anObject [

	^ runtime associationValue: anObject
]

{ #category : #visiting }
TqEvaluationContext >> method [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> method: anSCompiledMethod [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> methodArguments [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> nil [
	^ runtime nil
]

{ #category : #printing }
TqEvaluationContext >> printOn: aStream [
 self backtrace
				do: [ :frame | 
					frame
						do: [ :elem | elem printOn: aStream ]
						separatedBy: [ aStream nextPutAll: '. ' ].
					aStream cr ]
]

{ #category : #visiting }
TqEvaluationContext >> receiver [
	^self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> runtime: aTqRuntime [

	runtime := aTqRuntime
]

{ #category : #visiting }
TqEvaluationContext >> secondArgument [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> self [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> stackTemporaryAt: index [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> stackTemporaryAt: index put: value [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> staticBindingFor: symbol [
	(self staticBindingForIvar: symbol) ifNotNil: [ :b | ^ b ].
	(self staticBindingForCvar: symbol) ifNotNil: [ :b | ^ b ].
	^ self staticBindingForMvar: symbol
]

{ #category : #accessing }
TqEvaluationContext >> staticBindingForCvar: symbol [
	| species class nilObj cvars |
	species := runtime methodClassBinding: self method.
	class := runtime speciesInstanceClass: species.
	nilObj := runtime nil.
	[ cvars := runtime classCvars: class.
			cvars associationAtKey: symbol ifPresent: [ :assoc | ^ SAssociationBinding new association: assoc ].
	class := runtime speciesSuperclass: class.
	class = nilObj ] whileFalse.
	^ nil
]

{ #category : #accessing }
TqEvaluationContext >> staticBindingForIvar: aSymbol [
	| ivar |
	ivar := runtime staticBindingForIvar: aSymbol in: self self.
	^ ivar > 0
		ifTrue: [ TqInstVarBinding new index: ivar ]
]

{ #category : #accessing }
TqEvaluationContext >> staticBindingForMvar: symbol [

		| globals |
	globals := runtime globals.
	globals
		associationAtKey: symbol
		ifPresent: [ :assoc | ^ TqAssociationBinding new association: assoc ].
	self error: 'unbound variable: ' , symbol asString
]

{ #category : #services }
TqEvaluationContext >> storeAssociation: association value: anObject [

	runtime associationValue: association put: anObject
]

{ #category : #visiting }
TqEvaluationContext >> temporaryAt: index in: environmentIndex [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> temporaryAt: index in: environmentIndex put: value [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> thirdArgument [
	^ self subclassResponsibility
]

{ #category : #visiting }
TqEvaluationContext >> true [
	^ runtime true
]
