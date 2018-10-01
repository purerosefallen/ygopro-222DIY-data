--时终的溯行
function c65011009.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65011009)
	e1:SetTarget(c65011009.target)
	e1:SetOperation(c65011009.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65011009)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65011009.thtg)
	e2:SetOperation(c65011009.thop)
	c:RegisterEffect(e2)
end

function c65011009.thfilter(c)
	return c:IsSetCard(0xda2) and c:IsAbleToHand()
end
function c65011009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65011009.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65011009.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65011009.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c65011009.chanfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0xda2) 
end

function c65011009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65011009.chanfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65011009.chanfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectTarget(tp,c65011009.chanfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65011009.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	local sumtype=tc:GetSummonType()
	if tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_DISEFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		Duel.BreakEffect()
		if Duel.GetControl(tc,1-tp) and bit.band(sumtype,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
		and ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(aux.NecroValleyFilter(c65011009.mgfilter),nil,e,tp,tc,mg)==ct
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.SelectYesNo(tp,aux.Stringid(65011009,0)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c65011009.mgfilter(c,e,tp,fusc,mg)
	return c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and fusc:CheckFusionMaterial(mg,c)
end