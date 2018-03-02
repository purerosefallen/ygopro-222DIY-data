--上里翔流
function c5012637.initial_effect(c)
	c:SetUniqueOnField(1,1,5012637)
	--
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,5012604,aux.FilterBoolFunction(Card.IsSetCard,0x250),1,true)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c5012637.efilter)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c5012637.sprcon)
	e2:SetOperation(c5012637.sprop)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c5012637.drtg)
	e3:SetOperation(c5012637.drop)
	c:RegisterEffect(e3)
	if not c5012637.global_flag then
		c5012637.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c5012637.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c5012637.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(5012604) then
			Duel.RegisterFlagEffect(0,5012604,0,0,0)
		end
	end
end
function c5012637.efilter(e,re,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
function c5012637.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c5012637.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c5012637.matfilter(c)
	return (c:IsFusionCode(5012604) or c:IsFusionSetCard(0x250))
		and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER)
end
function c5012637.spfilter1(c,tp,g)
	return g:IsExists(c5012637.spfilter2,1,c,tp,c)
end
function c5012637.spfilter2(c,tp,mc)
	return (c:IsFusionCode(5012604) and mc:IsFusionSetCard(0x250)
		or mc:IsFusionCode(5012604) and c:IsFusionSetCard(0x250))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c5012637.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c5012637.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:IsExists(c5012637.spfilter1,1,nil,tp,g) and Duel.GetFlagEffect(0,5012604)>0
end
function c5012637.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c5012637.matfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:FilterSelect(tp,c5012637.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=g:FilterSelect(tp,c5012637.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

