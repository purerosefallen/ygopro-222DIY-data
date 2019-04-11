--原数黑姬 3
function c12011002.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12011002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,12011102)
	e1:SetTarget(c12011002.spstg)
	e1:SetOperation(c12011002.spsop)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c12011002.thcon)
	c:RegisterEffect(e2)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12011002,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,12011002)
	e2:SetCondition(c12011002.thcon)
	e2:SetTarget(c12011002.thtg)
	e2:SetOperation(c12011002.thop)
	c:RegisterEffect(e2)
	--be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c12011002.efcon)
	e3:SetOperation(c12011002.efop)
	c:RegisterEffect(e3)
end
function c12011002.efcon(e,tp,eg,ep,ev,re,r,rp)
	return ( r==REASON_LINK or r==REASON_SYNCHRO or r==REASON_XYZ )
end
function c12011002.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(12011002,2))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c12011002.settg)
	e1:SetOperation(c12011002.setop)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c12011002.setfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c12011002.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c12011002.setfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c12011002.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c12011002.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c12011002.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c12011002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),0x3fbe)
end
function c12011002.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c12011002.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12011002.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c12011002.spsop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c12011002.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c12011002.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c12011002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12011002.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12011002.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c12011002.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
end
