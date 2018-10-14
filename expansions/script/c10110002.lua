--元素火花 阿塔尔
function c10110002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10110002,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10110002.spcon)
	e1:SetOperation(c10110002.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10110002,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10110002)
	e2:SetTarget(c10110002.destg)
	e2:SetOperation(c10110002.desop)
	c:RegisterEffect(e2)
	--destroy and remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10110002,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,10110102)
	e3:SetTarget(c10110002.rmtg)
	e3:SetOperation(c10110002.rmop)
	c:RegisterEffect(e3)  
end
function c10110002.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c10110002.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
	   Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function c10110002.rmfilter(c)
	return c:IsSetCard(0x9332) and c:IsAbleToRemove()
end
function c10110002.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10110002.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10110002.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c10110002.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)~=0 then
	   Duel.BreakEffect()
	   Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c10110002.spfilter(c,ft)
	return (c:IsSetCard(0x9332) or c:IsAttribute(ATTRIBUTE_FIRE)) and c:IsAbleToRemoveAsCost() and (ft>0 or (c:GetSequence()<5 and c:IsOnField())) and c:IsType(TYPE_MONSTER)
end
function c10110002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c10110002.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,ft)
end
function c10110002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c10110002.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,c,ft):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(10110002,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetLabel(fid)
		e1:SetCountLimit(1)
		e1:SetCondition(c10110002.retcon)
		e1:SetOperation(c10110002.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10110002.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc,fid=e:GetLabelObject(),e:GetLabel()
	return tc:GetFlagEffectLabel(10110002)==fid
end
function c10110002.retop(e,tp,eg,ep,ev,re,r,rp)
	if tc:IsPreviousLocation(LOCATION_HAND) then
	   Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
	else
	   Duel.ReturnToField(tc)
	end
end