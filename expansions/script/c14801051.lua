--灾厄炎双 庞墩
function c14801051.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x4800),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_FIRE),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--attackall
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14801051,0))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,14801051)
	e3:SetCondition(c14801051.damcon)
	e3:SetCost(c14801051.damcost)
	e3:SetTarget(c14801051.damtg)
	e3:SetOperation(c14801051.damop)
	c:RegisterEffect(e3)
	--dambage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(14801051,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,148010511)
	e4:SetCost(aux.bfgcost)
	e4:SetCondition(c14801051.dambcon)
	e4:SetTarget(c14801051.dambtg)
	e4:SetOperation(c14801051.dambop)
	c:RegisterEffect(e4)
end
function c14801051.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetTurnPlayer()~=tp
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c14801051.costfilter(c)
	return (c:IsSetCard(0x4800) and c:IsType(TYPE_FUSION)) and c:IsAbleToGrave()
end
function c14801051.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14801051.costfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c14801051.costfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c14801051.ctfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c14801051.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14801051.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c14801051.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*400)
end
function c14801051.damop(e,tp,eg,ep,ev,re,r,rp)
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local ct=Duel.GetMatchingGroupCount(c14801051.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Damage(p,ct*400,REASON_EFFECT)
end
function c14801051.dambcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c14801051.dambtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0xe,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetFieldGroupCount(1-tp,0xe,0)*200
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c14801051.dambop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetFieldGroupCount(1-tp,0xe,0)*200
	Duel.Damage(p,dam,REASON_EFFECT)
end
