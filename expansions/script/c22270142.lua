--S.T. 最终兵器
function c22270142.initial_effect(c)
	c:EnableReviveLimit()
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
	e2:SetCountLimit(1,22270142)
	e2:SetCondition(c22270142.sprcon)
	e2:SetOperation(c22270142.sprop)
	c:RegisterEffect(e2)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22270142,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c22270142.destg)
	e1:SetOperation(c22270142.desop)
	c:RegisterEffect(e1)
end
c22270142.named_with_ShouMetsu_ToShi=1
function c22270142.IsShouMetsuToShi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ShouMetsu_ToShi
end
function c22270142.sprfilter(c)
	return c22270142.IsShouMetsuToShi(c) and c:IsAbleToRemoveAsCost()
end
function c22270142.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c22270142.sprfilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>2 and Duel.GetLocationCountFromEx(tp)>0
end
function c22270142.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22270142.sprfilter,tp,LOCATION_GRAVE,0,nil)
	if Duel.GetLocationCountFromEx(tp)<1 or g:GetClassCount(Card.GetCode)<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg2=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg3=g:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	sg1:Merge(sg3)
	Duel.Remove(sg1,POS_FACEUP,REASON_COST)
end
function c22270142.cfilter(c)
	return c22270142.IsShouMetsuToShi(c) and c:IsDestructable()
end
function c22270142.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22270142.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,0,0,0)
end
function c22270142.filter1(c,seq,tp)
	return (c:GetSequence()==seq and c:IsControler(tp)) or (c:GetSequence()==4-seq and c:IsControler(1-tp))
end
function c22270142.filter2(c,seq,tp)
	return (c:GetSequence()==1 and c:IsControler(tp)) or (c:GetSequence()==3 and c:IsControler(1-tp)) or (c:GetSequence()==5 and c:IsLocation(LOCATION_MZONE))
end
function c22270142.filter3(c,seq,tp)
	return (c:GetSequence()==3 and c:IsControler(tp)) or (c:GetSequence()==1 and c:IsControler(1-tp)) or (c:GetSequence()==6 and c:IsLocation(LOCATION_MZONE))
end
function c22270142.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c22270142.cfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local tc=Duel.SelectMatchingCard(tp,c22270142.cfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local seq=tc:GetSequence()
	if tc and Duel.Destroy(tc,REASON_EFFECT)<1 then return end
	Duel.BreakEffect()
	local tp=e:GetHandler():GetControler()
	if seq==0 or seq==2 or seq==4 then
		local g=Duel.GetMatchingGroup(c22270142.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,seq,tp)
		Duel.Destroy(g,REASON_EFFECT)
	elseif seq==1 or seq==5 then
		local g=Duel.GetMatchingGroup(c22270142.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,seq,tp)
		Duel.Destroy(g,REASON_EFFECT)
	elseif seq==3 or seq==6 then
		local g=Duel.GetMatchingGroup(c22270142.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,seq,tp)
		Duel.Destroy(g,REASON_EFFECT)
	end
end