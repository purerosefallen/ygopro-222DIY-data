--瓶中世界
function c65010118.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65010118)
	e1:SetOperation(c65010118.activate)
	c:RegisterEffect(e1) 
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetTarget(c65010118.tg)
	e2:SetValue(1)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e7)
	--change effect
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(65010118,1))
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_ACTIVATE)
	e8:SetCode(EVENT_CHAINING)
	e8:SetCountLimit(1,65010218)
	e8:SetCondition(c65010118.cecondition)
	e8:SetTarget(c65010118.cetarget)
	e8:SetOperation(c65010118.ceoperation)
	c:RegisterEffect(e8)
end
function c65010118.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5da0)
end
function c65010118.cecondition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsExistingMatchingCard(c65010118.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c65010118.spfilter(c,e,tp)
	return c:IsSetCard(0x5da0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c65010118.cetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010118.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
end
function c65010118.ceoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c65010118.repop)
end
function c65010118.repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(1-tp,c65010118.spfilter,1-tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end
function c65010118.tg(e,c)
	return c:GetControler()~=c:GetOwner()
end
function c65010118.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5da0) and c:IsAbleToHand()
end
function c65010118.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c65010118.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65010118,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end