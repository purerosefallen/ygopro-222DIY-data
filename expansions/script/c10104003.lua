--兹鲁夫咒符-奇点
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10104003
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)  
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	--move
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.mvtg)
	e4:SetOperation(cm.mvop)
	c:RegisterEffect(e4)
end
function cm.mvfilter(c,tp)
	if not c:IsLocation(LOCATION_MZONE) and c:GetSequence()>4 then return false end
	local seq1,seq2=nil
	local seq=rsv.GetExcatlySequence(c,tp)
	if seq==0 then seq2=seq+1
	elseif seq==4 then seq1=seq-1
	else seq1=seq-1 seq2=seq+1 
	end
	return (seq1 and Duel.CheckLocation(tp,LOCATION_MZONE,seq1)) or (seq2 and Duel.CheckLocation(tp,LOCATION_MZONE,seq2))
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec then return false end
	local g=Group.FromCards(c,ec)
	if chkc then return chkc:IsOnField() and not g:IsContains(chkc) and cm.mvfilter(chkc,tp) end
	if chk==0 then return ec and ec:IsControler(tp) and Duel.IsExistingTarget(cm.mvfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.mvfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g,tp)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	local ec=c:GetEquipTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or not ec:IsControler(tp) then return end
	if not tc:IsLocation(LOCATION_MZONE) and tc:GetSequence()>4 then return end
	local seq1,seq2
	local seq=rsv.GetExcatlySequence(tc,tp)
	if seq==0 then seq2=seq+1
	elseif seq==4 then seq1=seq-1
	else seq1=seq-1 seq2=seq+1
	end
	local zone1,zone2=0
	if seq1 then zone1=seq1^2 end
	if seq2 then zone2=seq2^2 end
	local zone=zone1+zone2
	if Duel.GetLocationCount(tp,LOCATION_MZONE,LOCATION_REASON_CONTROL,zone)<=0 then return end
	local flag=bit.bxor(zone,0xff)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(ec,nseq)
	if not ec:IsType(TYPE_LINK) then return end
	zone1=zone1*0x100
	zone2=zone2*0x100
	zone3=0x1f00-zone1-zone2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(cm.disop)
	e1:SetLabel(zone3)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetOperation(cm.setop)
	e2:SetCode(EVENT_ADJUST)
	Duel.RegisterEffect(e2,tp)
	e2:SetLabelObject(e1)
end
function cm.disop(e,tp)
	return e:GetLabel()
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	   Duel.BreakEffect()
	   local sg=g:Select(tp,1,1,nil)
	   Duel.HintSelection(sg)
	   Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEDOWN,false)
	   Duel.RaiseSingleEvent(sg:GetFirst(),EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	   Duel.RaiseEvent(sg:GetFirst(),EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	   Duel.ConfirmCards(1-tp,sg)
	end
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xa330) and c:IsSSetable()
end
function cm.efilter(e,re)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	if not re:IsActivated() then return false end
	local loc,seq,p=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	if p==tp then return false end
	seq=seq+16
	return (bit.band(loc,LOCATION_MZONE)~=0 and bit.extract(c:GetColumnZone(LOCATION_MZONE),seq)~=0
			or bit.band(loc,LOCATION_SZONE)~=0 and bit.extract(c:GetColumnZone(LOCATION_SZONE),seq)~=0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end