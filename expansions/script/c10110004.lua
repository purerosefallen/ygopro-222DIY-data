--元素火花 瓦由
function c10110004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10110004,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10110004.spcon)
	e1:SetOperation(c10110004.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(10110004,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,10110004)
	e2:SetLabel(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCost(c10110004.thcost)
	e2:SetTarget(c10110004.thtg)
	e2:SetOperation(c10110004.thop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10110004,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,10110004)
	e3:SetTarget(c10110004.thtg)
	e3:SetLabel(LOCATION_DECK)
	e3:SetOperation(c10110004.thop)
	c:RegisterEffect(e3)	
end
function c10110004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10110004.thfilter(c)
	return c:IsSetCard(0x9332) and c:IsAbleToHand() and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function c10110004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10110004.thfilter,tp,e:GetLabel(),0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,e:GetLabel())
end
function c10110004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10110004.thfilter),tp,e:GetLabel(),0,1,1,e:GetHandler())
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and e:GetLabel()==LOCATION_DECK then
	   Duel.ConfirmCards(1-tp,g)
	end
end
function c10110004.spfilter(c,ft)
	return (c:IsSetCard(0x9332) or c:IsAttribute(ATTRIBUTE_WIND)) and c:IsAbleToRemoveAsCost() and (ft>0 or (c:GetSequence()<5 and c:IsOnField())) and c:IsType(TYPE_MONSTER)
end
function c10110004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c10110004.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,ft)
end
function c10110004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c10110004.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,c,ft):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(10110004,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetLabel(fid)
		e1:SetCountLimit(1)
		e1:SetCondition(c10110004.retcon)
		e1:SetOperation(c10110004.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10110004.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc,fid=e:GetLabelObject(),e:GetLabel()
	return tc:GetFlagEffectLabel(10110004)==fid
end
function c10110004.retop(e,tp,eg,ep,ev,re,r,rp)
	if tc:IsPreviousLocation(LOCATION_HAND) then
	   Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
	else
	   Duel.ReturnToField(tc)
	end
end