--咒缚灵 黑骑士
function c10109012.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5332),2,2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10109012,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c10109012.cost)
	e1:SetOperation(c10109012.op)
	c:RegisterEffect(e1)  
	--set con
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EFFECT_SEND_REPLACE)
	ge1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	ge1:SetTarget(c10109012.reptg)
	ge1:SetValue(c10109012.repval)
	local g=Group.CreateGroup()
	g:KeepAlive()
	ge1:SetLabelObject(g)
	Duel.RegisterEffect(ge1,0)
end
function c10109012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
	   local e1=Effect.CreateEffect(c)
	   e1:SetCode(EFFECT_CHANGE_TYPE)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetReset(RESET_EVENT+0x1fc0000)
	   e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	   c:RegisterEffect(e1)
	   Duel.RaiseEvent(c,EVENT_CUSTOM+10109001,e,0,tp,0,0)
	end
end
function c10109012.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(c10109012.effectfilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
end
function c10109012.effectfilter(e,ct)
	local p=e:GetOwner():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x5332) and (bit.band(loc,LOCATION_ONFIELD)~=0 or bit.band(loc,LOCATION_HAND)~=0)
end
function c10109012.repfilter(c,rc)
	return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_LINK) and c:GetReasonCard()==rc and not c:IsForbidden()
end
function c10109012.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetOwner()
	local p=c:GetControler()
	if chk==0 then
	   return eg:IsExists(c10109012.repfilter,1,nil,c) and Duel.GetLocationCount(p,LOCATION_SZONE)>0
	end
	if Duel.SelectYesNo(p,aux.Stringid(10109012,0)) then
	   local g=e:GetLabelObject()
	   g:Clear()
	   Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOFIELD)
	   local tc=eg:FilterSelect(p,c10109012.repfilter,1,1,nil,c):GetFirst()
	   if Duel.MoveToField(tc,p,p,LOCATION_SZONE,POS_FACEUP,true) then
		  g:AddCard(tc)
		  local e1=Effect.CreateEffect(tc)
		  e1:SetCode(EFFECT_CHANGE_TYPE)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e1:SetReset(RESET_EVENT+0x1fc0000)
		  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		  tc:RegisterEffect(e1)
		  Duel.RaiseEvent(tc,EVENT_CUSTOM+10109001,e,0,p,0,0)
	   end
	   return true
	end
	return false
end
function c10109012.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
