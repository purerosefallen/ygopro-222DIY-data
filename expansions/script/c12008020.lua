--漆黑的质点 波恋达斯
function c12008020.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x1fb3),2,2)
	c:EnableReviveLimit()  
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12008020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c12008020.sptg)
	e1:SetOperation(c12008020.spop)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(12008020,1))
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,12008020)
	e2:SetTarget(c12008020.thtg)
	e2:SetOperation(c12008020.thop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetDescription(aux.Stringid(12008020,2))
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCountLimit(1,12008120)
	e3:SetCost(c12008020.rmcost)
	e3:SetOperation(c12008020.rmop)
	c:RegisterEffect(e3)
end
function c12008020.cfilter(c,g)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c12008020.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c12008020.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c12008020.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c12008020.rmop(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetHandler():GetFieldID()
	local og=Group.CreateGroup()
	og:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(og)
	e1:SetCondition(c12008020.hdcon)
	e1:SetOperation(c12008020.hdop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(fid)
	e2:SetLabelObject(og)
	e2:SetCondition(c12008020.retcon)
	e2:SetOperation(c12008020.retop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c12008020.retfilter(c,fid)
	return c:GetFlagEffectLabel(12008020)==fid
end
function c12008020.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c12008020.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c12008020.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c12008020.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
end
function c12008020.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c12008020.hdfilter(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(tp)
end
function c12008020.hdop(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local g=eg:Filter(c12008020.hdfilter,nil,1-tp)
	if g:GetCount()>0 then
	   Duel.Hint(HINT_CARD,0,12008020)
	end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
	   local og=Duel.GetOperatedGroup()
	   e:GetLabelObject():Merge(og)
	   for tc in aux.Next(og) do
		   tc:RegisterFlagEffect(12008020,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
	   end
	end
end
function c12008020.filter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c12008020.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c12008020.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12008020.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c12008020.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,99,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c12008020.limit)
	end
end
function c12008020.chainlimit(e,rp,tp)
	return tp==rp or not (e:GetHandler():IsFacedown() and e:GetHandler():IsOnField())
end
function c12008020.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
	   local ct=Duel.SendtoHand(tg,nil,REASON_EFFECT)
	   if ct~=0 then
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_UPDATE_ATTACK)
		  e1:SetReset(RESET_EVENT+0x1ff0000)
		  e1:SetValue(ct*400)
		  c:RegisterEffect(e1)
	   end
	end
end
function c12008020.spfilter(c,e,tp)
	return c:IsSetCard(0x1fb3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12008020.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c12008020.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c12008020.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c12008020.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c12008020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetRange(LOCATION_MZONE)
	   e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e1:SetTargetRange(0,1)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   e1:SetCondition(c12008020.accon)
	   e1:SetValue(c12008020.aclimit)
	   tc:RegisterEffect(e1,true)
	end
end
function c12008020.accon(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DRAW or ph==PHASE_STANDBY or ph==PHASE_END 
end
function c12008020.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

