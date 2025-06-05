#include "Presolve.h"

Presolve::Presolve(const HighsModel &_oriModel, const bool _initDone)
    : presolver_(),
      reducedSolution_(),
      oriObj_(INF)
{
  presolver_.setOptionValue("log_to_console", "false");
  presolver_.setOptionValue("mip_abs_gap", 0.0);
  presolver_.setOptionValue("mip_rel_gap", 0.0);
  // presolver_.setOptionValue("log_file", OPT(logPath) + "presolve.log");
  presolver_.setOptionValue("threads", 1);
  presolver_.passModel(_oriModel);
}
void Presolve::PresolveByHighs()
{
  presolver_.setOptionValue("primal_feasibility_tolerance", 1e-10);
  presolver_.setOptionValue("mip_feasibility_tolerance", 1e-10);
  presolver_.presolve();
}

void Presolve::PostSolveByHighs()
{
  presolver_.setOptionValue("primal_feasibility_tolerance", 1e-03);
  presolver_.setOptionValue("mip_feasibility_tolerance", 1e-03);
  presolver_.postsolve(reducedSolution_);
  oriObj_ = presolver_.getObjectiveValue();
}

void Presolve::PostSolveByHighs(const HighsSolution &_reducedSolution)
{
  presolver_.setOptionValue("primal_feasibility_tolerance", 1e-03);
  presolver_.setOptionValue("mip_feasibility_tolerance", 1e-03);
  presolver_.postsolve(_reducedSolution);
  oriObj_ = presolver_.getObjectiveValue();
}

bool Presolve::CheckPresolveInfeas()
{
  return presolver_.getModelPresolveStatus() == HighsPresolveStatus::kInfeasible ||
         presolver_.getModelPresolveStatus() == HighsPresolveStatus::kUnboundedOrInfeasible;
}

bool Presolve::CheckPresolveOptimal()
{
  return presolver_.getModelPresolveStatus() == HighsPresolveStatus::kReducedToEmpty;
}
