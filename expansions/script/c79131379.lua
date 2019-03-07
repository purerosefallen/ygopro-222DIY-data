--星罗魔导
function c79131379.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c79131379.ffilter,2,false)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c79131379.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c79131379.spcon)
	e2:SetOperation(c79131379.spop)
	c:RegisterEffect(e2)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,79131379)
	e3:SetTarget(c79131379.pctg)
	e3:SetOperation(c79131379.pcop)
	c:RegisterEffect(e3)
	--Set in P.Zone
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,79131380)
	e4:SetTarget(c79131379.pztg)
	e4:SetOperation(c79131379.pzop) 
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(79131379,0))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,79131381)
	e5:SetCondition(c79131379.negcon)
	e5:SetTarget(c79131379.negtg)
	e5:SetOperation(c79131379.negop)
	c:RegisterEffect(e5)
end
function c79131379.ffilter(c)
	return c:IsFusionSetCard(0x79a)
end
function c79131379.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c79131379.spfilter(c,fc)
	return c79131379.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c79131379.spfilter1(c,tp,g)
	return g:IsExists(c79131379.spfilter2,1,c,tp,c)
end
function c79131379.spfilter2(c,tp,mc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c79131379.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp):Filter(c79131379.spfilter,nil,c)
	return g:IsExists(c79131379.spfilter1,1,nil,tp,g)
end
function c79131379.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp):Filter(c79131379.spfilter,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=g:FilterSelect(tp,c79131379.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=g:FilterSelect(tp,c79131379.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c79131379.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x79a) and not c:IsForbidden()
end
function c79131379.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c79131379.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c79131379.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c79131379.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c79131379.pzfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7)  
end
function c79131379.pzfilter2(c)
	return c:IsFaceup() and c:IsCode(79131379)
end
function c79131379.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c79131379.pzfilter,tp,LOCATION_SZONE,0,nil)<2 and Duel.IsExistingMatchingCard(c79131379.pzfilter2,tp,LOCATION_EXTRA,0,1,nil) end
end
function c79131379.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c79131379.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c79131379.desfilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and c:IsSetCard(0x79a)
end
function c79131379.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79131379.desfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79131379.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c79131379.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g1:GetCount()>0 and Duel.Destroy(g1,REASON_EFFECT)~=0 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end