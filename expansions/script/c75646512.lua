--月下协奏曲 柯罗伊
function c75646512.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x32c3),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c75646512.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c75646512.spcon)
	e2:SetOperation(c75646512.spop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646512,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetTarget(c75646512.cttg)
	e3:SetOperation(c75646512.ctop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75646512,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c75646512.damtg)
	e4:SetOperation(c75646512.damop)
	c:RegisterEffect(e4)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(75646512,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(aux.bdocon)
	e5:SetTarget(c75646512.settg)
	e5:SetOperation(c75646512.setop)
	c:RegisterEffect(e5)  
end
function c75646512.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c75646512.spfilter(c,fc)
	return (c:IsFusionSetCard(0x32c3) or c:IsFusionAttribute(ATTRIBUTE_DARK)) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function c75646512.spfilter1(c,tp,g)
	return g:IsExists(c75646512.spfilter2,1,c,tp,c)
end
function c75646512.spfilter2(c,tp,mc)
	return (c:IsFusionSetCard(0x32c3) and mc:IsFusionAttribute(ATTRIBUTE_DARK) or c:IsFusionAttribute(ATTRIBUTE_DARK) and mc:IsFusionSetCard(0x32c3))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c75646512.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c75646512.spfilter,tp,LOCATION_MZONE,0,nil,c)
	return g:IsExists(c75646512.spfilter1,1,nil,tp,g)
end
function c75646512.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c75646512.spfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,c75646512.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=g:FilterSelect(tp,c75646512.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c75646512.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x12c3,1)
end
function c75646512.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646512.ctfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x12c3)
end
function c75646512.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c75646512.ctfilter,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x12c3,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c75646512.atkcon)
		e1:SetValue(-1000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c75646512.atkcon(e)
	return e:GetHandler():GetCounter(0x12c3)>0
end
function c75646512.damfilter(c)
	return c:GetCounter(0x12c3)>0
end
function c75646512.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c75646512.damfilter,tp,0,LOCATION_ONFIELD,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1,0,0)  
end
function c75646512.damop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c75646512.damfilter,tp,0,LOCATION_ONFIELD,nil)
	local t=g:GetFirst()
	local sum=0
	while t do
	   local sct=t:GetCounter(0x12c3)
	   t:RemoveCounter(tp,0x12c3,t:GetCounter(0x12c3),REASON_EFFECT)
	   sum=sum+sct
	   Duel.NegateRelatedChain(t,RESET_TURN_SET)
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_DISABLE)
	   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	   t:RegisterEffect(e1)
	   local e2=Effect.CreateEffect(e:GetHandler())
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetCode(EFFECT_DISABLE_EFFECT)
	   e2:SetValue(RESET_TURN_SET)
	   e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	   t:RegisterEffect(e2)
	   t=g:GetNext()
	end
	Duel.Damage(1-tp,sum*500,REASON_EFFECT)
end
function c75646512.filter(c)
	return c:IsCode(75646510) and c:IsSSetable()
end
function c75646512.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c75646512.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75646512.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end