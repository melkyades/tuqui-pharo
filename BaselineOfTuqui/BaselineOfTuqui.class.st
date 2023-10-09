Class {
	#name : #BaselineOfTuqui,
	#superclass : #BaselineOf,
	#category : #BaselineOfTuqui
}

{ #category : #baselines }
BaselineOfTuqui >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec baseline: 'Powerlang' with: [
			spec loads: 'SCompiler'.
			spec repository: 'github://powerlang/powerlang:main/src'
		].

		spec package: 'Tuqui-Evaluation' with:[
			spec requires: 'Powerlang-SCompiler'.
		].

		spec package: 'Tuqui-Tests'.

		"compiler group: just compiler and compiler tests"
		spec group: 'base' with: #(
											'Tuqui-Evaluation'
											'Tuqui-Tests').

		"devel group: base, tests and custom dev tools"
		spec group: 'devel' with: #('base').

		"default group: loaded when group is not specified"
		spec group: 'default' with: #('devel').
	].


]
