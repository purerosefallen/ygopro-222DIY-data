--超能回弹士
function c10173055.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c10173055.ffilter,2,true)
	--rjp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10173055.reptg)
	e2:SetOperation(c10173055.repop)
	c:RegisterEffect(e2)
	--back
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c10173055.tfcon)
	e3:SetOperation(c10173055.tfop)
	c:RegisterEffect(e3)
	e3:SetLabelObject(e2)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetDescription(aux.Stringid(10173055,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c10173055.tdtg)
	e4:SetOperation(c10173055.tdop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CUSTOM+10173055)
	c:RegisterEffect(e5)
end
function c10173055.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:IsExists(Card.IsFusionAttribute,1,nil,c:GetFusionAttribute())
end
function c10173055.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c10173055.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c10173055.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c10173055.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g,re=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_EFFECT)
	if chk==0 then return c:IsFaceup() and c:GetReasonPlayer()~=tp and (not re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g:IsContains(c))  end
	return true
end
function c10173055.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_REDIRECT+REASON_TEMPORARY+REASON_EFFECT)
end
function c10173055.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return re and e:GetLabelObject()==re
end
function c10173055.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,10173055)
	if Duel.ReturnToField(c,POS_FACEUP_DEFENSE) then
	   Duel.RaiseSingleEvent(c,EVENT_CUSTOM+10173055,e,0,tp,0,0)
	end
end