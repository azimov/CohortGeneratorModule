# This file has been autogenerated in 'extras/ModuleMaintenance.R'. Do not change by hand. 
# Copyright 2022 Observational Health Data Sciences and Informatics
#
# This file is part of CohortGeneratorModule
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Create specifications for the CohortGeneratorModule
#'
#' @param incremental Should the CohortGenerator module run in incremental mode?
#'                    
#' @param generateStats Should the CohortGenerator module generate cohort statistics?
#'                    
#'
#' @return
#' An object of type `CohortGeneratorModuleSpecifications`.
#'
#' @export
createCohortGeneratorModuleSpecifications <- function(incremental = TRUE,
                                                      generateStats = TRUE) {
  analysis <- list()
  for (name in names(formals(createCohortGeneratorModuleSpecifications))) {
    analysis[[name]] <- get(name)
  }
  
  specifications <- list(module = "CohortGeneratorModule",
                         version = "0.0.16",
                         remoteRepo = "github.com",
                         remoteUsername = "ohdsi",
                         settings = analysis)
  class(specifications) <- c("CohortGeneratorModuleSpecifications", "ModuleSpecifications")
  return(specifications)
}

#' Create shared specifications for the cohort definition set
#'
#' @param cohortDefinitionSet The cohortDefintionSet holds the cohortId, cohortName and json
#'                            specification for the cohorts of interest.
#'
#' @return
#' An object of type `CohortDefinitionSharedResources`.
#'
#' @export
createCohortSharedResourceSpecifications <- function(cohortDefinitionSet) {
  if (!CohortGenerator::isCohortDefinitionSet(cohortDefinitionSet)) {
    stop("cohortDefinitionSet is not properly defined")
  }
  
  sharedResource <- list()
  
  subsetDefinitions <- CohortGenerator::getSubsetDefinitions(cohortDefinitionSet)
  if (length(subsetDefinitions)) {
    sharedResource$subsetDefinitions <- lapply(subsetDefinitions, function(x) { x$toJSON()})
    cohortDefinitionSet <- cohortDefinitionSet[!cohortDefinitionSet$isSubset, ]
  }
  
  cohortDefinitionSet <- cohortDefinitionSet[,c("cohortId", "cohortName", "json")]
  names(cohortDefinitionSet) <- c("cohortId", "cohortName", "cohortDefinition")
  print(cohortDefinitionSet[,c("cohortId", "cohortName")])
  cohortDefinitionSet <- apply(cohortDefinitionSet, 1, as.list)
  sharedResource$cohortDefinitions <- cohortDefinitionSet
   
  class(sharedResource) <- c("CohortDefinitionSharedResources", "SharedResources")
  return(sharedResource)
}

#' Create shared specifications for the negative control outcome
#' cohort set
#'
#' @param negativeControlOutcomeCohortSet	The negativeControlOutcomeCohortSet argument 
#' must be a data frame with the following columns: cohortId, cohortName, outcomeConceptId
#' 
#' @param occurrenceType The occurrenceType will detect either: the first time an 
#'                       outcomeConceptId occurs or all times the outcomeConceptId 
#'                       occurs for a person. Values accepted: 'all' or 'first'.
#' 
#' @param detectOnDescendants When set to TRUE, detectOnDescendants will use the vocabulary 
#'                            to find negative control outcomes using the outcomeConceptId and all 
#'                            descendants via the concept_ancestor table. When FALSE, only the exact 
#'                            outcomeConceptId will be used to detect the outcome.
#'
#' @return
#' An object of type `CohortDefinitionSharedResources`.
#'
#' @export
createNegativeControlOutcomeCohortSharedResourceSpecifications <- function(negativeControlOutcomeCohortSet,
                                                                           occurrenceType,
                                                                           detectOnDescendants) {
  negativeControlOutcomeCohortSet <- apply(negativeControlOutcomeCohortSet, 1, as.list)
  sharedResource <- list(
    negativeControlOutcomes = list(
      negativeControlOutcomeCohortSet = negativeControlOutcomeCohortSet,
      occurrenceType = occurrenceType,
      detectOnDescendants = detectOnDescendants)
  )
  class(sharedResource) <- c("NegativeControlOutcomeSharedResources", "SharedResources")
  return(sharedResource)
}
