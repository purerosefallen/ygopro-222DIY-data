--秘谈·迷幻的晨曦
local m=1111007
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Legend=true
--
function c1111007.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DISABLE+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1111007+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1111007.tg1)
	e1:SetOperation(c1111007.op1)
	c:RegisterEffect(e1)
--
end
--
function c1111007.tfilter1(c)
	local p=c:GetControler()
	return Duel.IsPlayerCanDraw(p,1)
end
function c1111007.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1111007.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1111007.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1111007.tfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local p=tc:GetControler()
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,p,1)
end
--
function c1111007.ofilter1(c,tc)
	return c:IsRace(tc:GetRace()) and c:IsAbleToHand()
end
function c1111007.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local p=tc:GetControler()
	if Duel.Draw(p,1,REASON_EFFECT)<1 then return end
	local b1=(tc:IsFaceup() and not tc:IsDisabled())
	local b2=Duel.IsExistingMatchingCard(c1111007.ofilter1,p,LOCATION_MZONE,LOCATION_MZONE,1,tc,tc)
	local b3=true
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1111007,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1111007,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(1111007,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_1)
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_2:SetType(EFFECT_TYPE_SINGLE)
		e1_2:SetCode(EFFECT_DISABLE)
		e1_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_2)
		local e1_3=Effect.CreateEffect(c)
		e1_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_3:SetType(EFFECT_TYPE_SINGLE)
		e1_3:SetCode(EFFECT_DISABLE_EFFECT)
		e1_3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_3)
	elseif sel==2 then
		local gn=Duel.GetMatchingGroup(c1111007.ofilter1,tp,LOCATION_MZONE,LOCATION_MZONE,tc,tc)
		if gn:GetCount()<=0 then return end
		Duel.SendtoHand(gn,nil,REASON_EFFECT)
	else
		local e1_4=Effect.CreateEffect(c)
		e1_4:SetType(EFFECT_TYPE_FIELD)
		e1_4:SetCode(EFFECT_IMMUNE_EFFECT)
		e1_4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1_4:SetTarget(c1111007.tg1_4)
		e1_4:SetValue(c1111007.val1_4)
		e1_4:SetLabelObject(tc)
		e1_4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_4,tp)
	end
end
--
function c1111007.tg1_4(e,c)
	local tc=e:GetLabelObject()
	local p=tc:GetControler()
	return c:IsControler(p)
end
function c1111007.val1_4(e,re)
	local tc=e:GetLabelObject()
	local p=tc:GetControler()
	return re:GetOwnerPlayer()==p and re:GetOwner()~=e:GetOwner()
end
--
