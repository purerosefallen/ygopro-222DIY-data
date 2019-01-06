--光之救世主 蓬莱寺九霄
function c75646062.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c75646063.lcheck)
	c:EnableReviveLimit()
	--apply effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646062,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,75646062)
	e1:SetCost(c75646062.effcost)
	e1:SetTarget(c75646062.efftg)
	e1:SetOperation(c75646062.effop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(75646062,ACTIVITY_SPSUMMON,c75646062.counterfilter)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c75646062.chaincon)
	e4:SetOperation(c75646062.chainop)
	c:RegisterEffect(e4)
end
c75646062.is_named_with_Kyuusyou=1
function c75646062.IsKYUUSYOU(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Kyuusyou
end
function c75646063.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x2c0)
end
function c75646062.counterfilter(c)
	return c:IsSetCard(0x2c0) or c:GetSummonLocation()~=LOCATION_EXTRA 
end
function c75646062.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(75646062,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c75646062.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c75646062.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x2c0) and c:IsLocation(LOCATION_EXTRA)
end
function c75646062.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x2c0) and c:IsType(TYPE_XYZ) and c:IsFaceup()) then return false end
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local te=m.xyz_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c75646062.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and chkc:IsControler(tp) and c75646062.efffilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(c75646062.efffilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c75646062.efffilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local m=_G["c"..tc:GetCode()]
	local te=m.xyz_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c75646062.effop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local m=_G["c"..tc:GetCode()]
		local te=m.xyz_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function c75646062.chaincon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c75646062.chainop(e,tp,eg,ep,ev,re,r,rp)
	local es=re:GetHandler()
	if es:IsSetCard(0x2c0) and es:IsType(TYPE_EQUIP) 
		and es:GetEquipTarget()==e:GetHandler() and re:IsActiveType(TYPE_SPELL) and ep==tp then
		Duel.SetChainLimit(aux.FALSE)
	end
end