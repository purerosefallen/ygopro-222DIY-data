--秘谈·灵引的烛龙
local m=1111016
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Legend=true
--
function c1111016.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111016.tg1)
	e1:SetOperation(c1111016.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111016,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1111016)
	e2:SetCondition(c1111016.con2)
	e2:SetTarget(c1111016.tg2)
	e2:SetOperation(c1111016.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111016.tfilter1(c,ft)
	return (c:IsType(TYPE_FIELD) or (ft>0 and c:IsType(TYPE_SPELL))) and muxu.check_set_Border(c) and not c:IsForbidden()
end
function c1111016.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111016.tfilter1,tp,LOCATION_DECK,0,1,nil,ft) end
end
--
function c1111016.tfilter1(c)
	return c:IsType(TYPE_FIELD) and muxu.check_set_Border(c) and not c:IsForbidden()
end
function c1111016.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111016,0))
	local g=Group.CreateGroup()
	if ft>0 then g=Duel.SelectMatchingCard(tp,c1111016.tfilter1,tp,LOCATION_DECK,0,1,1,nil,ft) end
	if g:GetCount()<=0 then g=Duel.SelectMatchingCard(tp,c1111016.ofilter1,tp,LOCATION_DECK,0,1,1,nil) end
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then Duel.SendtoGrave(fc,REASON_RULE) end
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_1:SetRange(LOCATION_FZONE+LOCATION_SZONE)
	e1_1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1_1:SetValue(c1111016.val1_2)
	e1_1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1_1)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_2:SetCode(EVENT_PHASE+PHASE_END)
	e1_2:SetRange(LOCATION_FZONE+LOCATION_SZONE)
	e1_2:SetCountLimit(1)
	e1_2:SetOperation(c1111016.op1_2)
	e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1_2)
end
--
function c1111016.val1_2(e,te)
	return te:IsActiveType(TYPE_MONSTER) and e:GetHandlerPlayer()~=te:GetOwnerPlayer()
end
function c1111016.op1_2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
--
function c1111016.cfilter2(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_SPIRIT)
end
function c1111016.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1111016.cfilter2,1,nil,tp)
end
--
function c1111016.tfilter2(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_SPIRIT) and c:IsAbleToHand()
end
function c1111016.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:IsExists(c1111016.tfilter2,1,nil,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
--
function c1111016.ofilter2_1(c,e,tp)
	return c:IsControler(tp) and c:IsType(TYPE_SPIRIT) and c:IsAbleToHand() and c:IsRelateToEffect(e)
end
function c1111016.ofilter2_2(c)
	return c:IsLocation(LOCATION_HAND)
end
function c1111016.ofilter2_5(c,gn)
	local checknum=0
	local tc=gn:GetFirst()
	while tc do
		if c:GetLevel()==tc:GetLevel() then checknum=1 end
		tc=gn:GetNext()
	end
	return c:IsType(TYPE_SPIRIT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and checknum==1
end
function c1111016.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:IsExists(c1111016.ofilter2_1,1,nil,e,tp)
	if g:GetCount()<=0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local gn=g:Filter(c1111016.ofilter2_2,nil)
	if gn:GetCount()<=0 then return end
	local tc=gn:GetFirst()
	while tc do
		local e2_3=Effect.CreateEffect(c)
		e2_3:SetType(EFFECT_TYPE_SINGLE)
		e2_3:SetCode(EFFECT_PUBLIC)
		e2_3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_3)
		tc:RegisterFlagEffect(1111016,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		tc:RegisterFlagEffect(1111016,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1111016,2))
		tc=gn:GetNext()
	end
	if Duel.GetFlagEffect(tp,1111016)<=0 and Duel.GetFlagEffect(tp,1111016)<=0 then
		local e2_4=Effect.CreateEffect(c)
		e2_4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e2_4:SetType(EFFECT_TYPE_FIELD)
		e2_4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2_4:SetTargetRange(1,1)
		e2_4:SetCondition(c1111016.con2_4)
		e2_4:SetTarget(c1111016.tg2_4)
		Duel.RegisterEffect(e2_4,tp)
		Duel.RegisterFlagEffect(tp,1111016,0,0,0)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsExistingMatchingCard(c1111016.ofilter2_5,tp,LOCATION_GRAVE,0,1,nil,gn) and Duel.SelectYesNo(tp,aux.Stringid(1111016,3)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c1111016.ofilter2_5,tp,LOCATION_GRAVE,0,1,1,nil,gn)
		if sg:GetCount()>0 then
			local sc=sg:GetFirst()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--
function c1111016.cfilter2_4(c)
	return c:IsFaceup() and muxu.check_set_Border(c)
end
function c1111016.con2_4(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c1111016.cfilter2_4,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c1111016.tg2_4(e,c,sump,sumtype,sumpos,targetp,se)
	return se:IsHasType(EFFECT_TYPE_ACTIONS) and c:GetFlagEffect(1111016)>0
end
--
