--深林之茵瑟克塔
function c65011021.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c65011021.sprcon)
	e0:SetOperation(c65011021.sprop)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65011021,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c65011021.eqtg)
	e1:SetOperation(c65011021.eqop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65011021.condition)
	e2:SetCost(c65011021.cost)
	e2:SetTarget(c65011021.target)
	e2:SetOperation(c65011021.activate)
	c:RegisterEffect(e2)
end
function c65011021.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandlerPlayer()~=tp and Duel.IsChainNegatable(ev)
end
function c65011021.costfil(c,nc,tc)
	local att=tc:GetAttribute()
	local rac=tc:GetRace()
	if not tc:IsType(TYPE_MONSTER) then 
		att=tc:GetPreviousAttributeOnField()
		rac=tc:GetPreviousRaceOnField()
	end
	return c:GetEquipTarget()==nc and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and (c:GetOriginalAttribute()==att or c:GetOriginalRace()==rac) and c:IsAbleToGraveAsCost()
end
function c65011021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local nc=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65011021.costfil,tp,LOCATION_SZONE,0,1,nc,nc,tc) end
	local g=Duel.SelectMatchingCard(tp,c65011021.costfil,tp,LOCATION_SZONE,0,1,1,nc,nc,tc)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65011021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c65011021.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,REASON_EFFECT)
	end
end



function c65011021.eqfil(c)
	return c:IsPosition(POS_FACEUP_DEFENSE) and c:IsAbleToChangeControler()
end
function c65011021.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsPosition(POS_FACEUP_DEFENSE) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c65011021.eqfil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c65011021.eqfil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c65011021.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c65011021.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c65011021.eqlimit(e,c)
	return e:GetOwner()==c
end

function c65011021.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c65011021.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(c65011021.sprfilter2,1,c,tp,c,sc,lv)
end
function c65011021.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:GetLevel()==lv-6 and c:GetOriginalLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsRace(RACE_INSECT)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c65011021.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65011021.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c65011021.sprfilter1,1,nil,tp,g,c)
end
function c65011021.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c65011021.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c65011021.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c65011021.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end