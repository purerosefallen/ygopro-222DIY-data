--折合拆分
function c21520178.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520178,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21520178.target)
	e1:SetOperation(c21520178.activate)
	c:RegisterEffect(e1)
	--to field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520178,1))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c21520178.sscost)
	e2:SetTarget(c21520178.sstg)
	e2:SetOperation(c21520178.ssop)
	c:RegisterEffect(e2)
end
function c21520178.thfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0x490) 
		and Duel.IsExistingMatchingCard(c21520178.spfilter,tp,LOCATION_DECK,0,1,nil,lv,e,tp,c)
end
function c21520178.spfilter(c,lv,e,tp,tc)
	if tc:IsSetCard(0x5490) then 
		return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x490) and not c:IsSetCard(0x5490)
	else 
		return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x5490)
	end
end
function c21520178.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c21520178.thfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingTarget(c21520178.thfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c21520178.thfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21520178.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21520178.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel(),e,tp,tc)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21520178.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c21520178.ssfilter(c)
	return c:IsSetCard(0x490) and c:IsType(TYPE_MONSTER)
end
function c21520178.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520178.ssfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c21520178.ssop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(c21520178.ssfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local ct=Duel.SelectOption(tp,aux.Stringid(21520178,2),aux.Stringid(21520178,3))
	local typ=0
	if ct==0 then typ=TYPE_SPELL+TYPE_CONTINUOUS 
	else typ=TYPE_TRAP+TYPE_CONTINUOUS end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg=g:Select(tp,1,math.min(3,ft),nil)
	for tc in aux.Next(tg) do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(21520178,ct+2))
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(typ)
		tc:RegisterEffect(e1)
	end
end
