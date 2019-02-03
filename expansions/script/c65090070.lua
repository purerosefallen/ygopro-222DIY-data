--天邪逆鬼的镜界
function c65090070.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65090070)
	e1:SetTarget(c65090070.tg)
	e1:SetOperation(c65090070.op)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c65090070.reptg)
	e2:SetValue(c65090070.repval)
	e2:SetOperation(c65090070.repop)
	c:RegisterEffect(e2)
end
function c65090070.refil(c)
	return c:IsSetCard(0x9da7) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c65090070.spfil(c,e,tp)
	return c:IsSetCard(0x9da7) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65090070.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c65090070.thfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65090070.spfil,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c65090070.refil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectTarget(tp,c65090070.spfil,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c65090070.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c65090070.refil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65090070.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9da4) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c65090070.rpfil(c)
	return c:IsSetCard(0x9da4) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToDeck()
end
function c65090070.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65090070.rpfil,tp,LOCATION_REMOVED,0,2,nil) and eg:IsExists(c65090070.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c65090070.repval(e,c)
	return c65090070.repfilter(c,e:GetHandlerPlayer())
end
function c65090070.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65090070.rpfil,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end