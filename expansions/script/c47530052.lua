--Hi-v高达
function c47530052.initial_effect(c)
	c:SetUniqueOnField(1,0,47530052)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c47530052.sprcon)
	e2:SetOperation(c47530052.sprop)
	c:RegisterEffect(e2) 
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c47530052.efilter)
	c:RegisterEffect(e3)   
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(47530052,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c47530052.fftg)
	e5:SetOperation(c47530052.ffop)
	c:RegisterEffect(e5)
end
function c47530052.sprfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsReleasable()
end
function c47530052.sprfilter1(c)
	return c:IsType(TYPE_TUNER) and c:IsRace(RACE_MACHINE)
end
function c47530052.sprfilter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsLinkAbove(4)
end
function c47530052.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c47530052.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c47530052.sprfilter1,1,nil,tp,g,c)
end
function c47530052.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c47530052.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c47530052.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c47530052.sprfilter2,1,1,nil,tp,g)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c47530052.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c47530052.fftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47530052.ffop(e,tp,eg,ep,ev,re,r,rp)
	local ct=6
	while ct>0 and Duel.SelectYesNo(tp,aux.Stringid(47530052,1)) do
		if ct<6 then Duel.BreakEffect() end
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		local tc=g:GetFirst()
		local res=Duel.TossCoin(tp,1)
		if tc and res==1 then
			Duel.Destroy(tc,REASON_EFFECT)
		end
		ct=ct-1
	end
end