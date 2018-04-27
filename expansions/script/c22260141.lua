--神速 七夜志贵
function c22260141.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1)
	e1:SetCondition(c22260141.condition)
	e1:SetTarget(c22260141.target)
	e1:SetOperation(c22260141.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c22260141.val)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22260141,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c22260141.ccost)
	e3:SetOperation(c22260141.cbop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22260141,2))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c22260141.cecon)
	e4:SetCost(c22260141.ccost)
	e4:SetTarget(c22260141.cetg)
	e4:SetOperation(c22260141.ceop)
	c:RegisterEffect(e4)
end
c22260141.named_with_NanayaShiki=1
function c22260141.IsNanayaShiki(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_NanayaShiki
end
function c22260141.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c22260141.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSpecialSummonable(SUMMON_TYPE_SYNCHRO) end
end
function c22260141.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(22260141,0)) then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
		Duel.SpecialSummonRule(tp,c,SUMMON_TYPE_SYNCHRO)
	end
end
function c22260141.val(e,c)
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)*700
end
function c22260141.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(e:GetHandler(),nseq)
end
function c22260141.cbop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c22260141.cecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and Duel.IsChainDisablable(ev)
end
function c22260141.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c22260141.ceop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateEffect(ev)
end