--超钢巨人 激钢神
function c47531096.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c47531096.mfilter,c47531096.xyzcheck,2,2)	 
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(47531096,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,47530097)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c47531096.cost)
	e1:SetTarget(c47531096.thtg)
	e1:SetOperation(c47531096.thop)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47531096,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(c47531096.cfilter))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_EXTRA_SET_COUNT)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47531096,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetTarget(c47531096.ovtg)
	e4:SetOperation(c47531096.ovop)
	c:RegisterEffect(e4)
end
function c47531096.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsLevelAbove(1)
end
function c47531096.xyzcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount() and g:GetClassCount(Card.GetLinkAttribute)==g:GetCount() and g:GetClassCount(Card.GetLevel)==g:GetCount()
end
function c47531096.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47531096.thfilter(c)
	return c:IsCode(47594147) and not c:IsForbidden()
end
function c47531096.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47531096.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47531096.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47531096.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c47531096.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c47531096.splimit(e,c)
	return not c:IsRace(RACE_MACHINE) and c:IsLocation(LOCATION_EXTRA)
end
function c47531096.cfilter(c,tp)
	return not (Duel.IsExistingMatchingCard(c47531096.drfilter1,tp,LOCATION_MZONE,0,1,c,c:GetCode()) and Duel.IsExistingMatchingCard(c47531096.drfilter2,tp,LOCATION_MZONE,0,1,c,c:GetRace()) and Duel.IsExistingMatchingCard(c47531096.drfilter3,tp,LOCATION_MZONE,0,1,c,c:GetAttribute()) and Duel.IsExistingMatchingCard(c47531096.drfilter4,tp,LOCATION_MZONE,0,1,c,c:GetLevel()))
end
function c47531096.drfilter1(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c47531096.drfilter2(c,rc)
	return c:IsFaceup() and c:IsRace(rc)
end
function c47531096.drfilter3(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c47531096.drfilter4(c,lv)
	return c:IsFaceup() and c:IsLevel(lv)
end
function c47531096.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
end
function c47531096.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c47531096.ovfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c47531096.ovfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c47531096.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c47531096.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
