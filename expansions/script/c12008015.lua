--双色的齐彩
function c12008015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--dddddd
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008015,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c12008015.condition)
	e2:SetTarget(c12008015.targetx)
	e2:SetOperation(c12008015.operation)
	c:RegisterEffect(e2)  
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c12008015.target)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--attribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e4:SetTarget(c12008015.target)
	e4:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e4)  
	--immune (FAQ in Card Target)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c12008015.target)
	e5:SetValue(c12008015.efilter)
	c:RegisterEffect(e5)
end
function c12008015.target(e,c)
	local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
	if not c12008015.target(e,c) then return false end
	return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c12008015.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c12008015.target(e,c)
	local tp=e:GetHandlerPlayer()
	local tg=Duel.GetMatchingGroup(c12008015.cccfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(tg) do
		if tc:GetLinkedGroup():IsContains(c) then return true end
	end
	return false
end
function c12008015.cccfilter(c)
	return not c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) and not c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) and not c:IsLinkMarker(LINK_MARKER_TOP_LEFT) and not c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) 
end
function c12008015.ccfilter(c)
	return c12008015.cccfilter(c) and c:GetMutualLinkedGroupCount()>0 and c12008015.cfilter(c)
end
function c12008015.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c12008015.condition(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c12008015.ccfilter,1,nil) then
	   e:SetLabel(100)
	else 
	   e:SetLabel(0)
	end
	return eg:IsExists(c12008015.cfilter,1,nil)
end
function c12008015.targetx(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
	if e:GetLabel()==100 then
	   e:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	else
	   e:SetCategory(CATEGORY_REMOVE)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetChainLimit(c12008015.chlimit)
end
function c12008015.chlimit(e,ep,tp)
	return tp==ep
end
function c12008015.operation(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()<=0 or Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)<=0 then return end
	local fid=c:GetFieldID()
	local tc=g:GetFirst()
	tc:RegisterFlagEffect(12008015,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(tc)
	e1:SetCondition(c12008015.retcon)
	e1:SetOperation(c12008015.retop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetDescription(aux.Stringid(12008015,2))
	Duel.RegisterEffect(e1,tp)
	if e:GetLabel()==100 and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(12008015,1)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c12008015.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:GetFlagEffectLabel(12008015)==e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c12008015.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
end
