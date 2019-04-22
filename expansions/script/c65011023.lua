--溶解之弗路亚
function c65011023.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c65011023.sprcon)
	e0:SetOperation(c65011023.sprop)
	c:RegisterEffect(e0)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65011023.cecondition)
	e1:SetTarget(c65011023.cetarget)
	e1:SetOperation(c65011023.ceoperation)
	c:RegisterEffect(e1)
end
function c65011023.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(1-tp,c65011023.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c65011023.cecondition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp 
end
function c65011023.filter(c)
	return c:IsFaceup() and c:IsDestructable() and not c:IsCode(65011023)
end
function c65011023.cetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65011023.filter,rp,0,LOCATION_MZONE,1,nil) end
end
function c65011023.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c65011023.repop)
end

function c65011023.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c65011023.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(c65011023.sprfilter2,1,c,tp,c,sc,lv)
end
function c65011023.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:GetLevel()==lv-2 and c:GetOriginalLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsRace(RACE_AQUA)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c65011023.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65011023.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c65011023.sprfilter1,1,nil,tp,g,c)
end
function c65011023.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c65011023.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c65011023.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c65011023.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end