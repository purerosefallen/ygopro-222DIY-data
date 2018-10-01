--时终结 圣杯
function c65011010.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.TRUE,aux.TRUE,true)
	aux.AddFusionProcCode2(c,65011003,65011004,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c65011010.rectg)
	e2:SetOperation(c65011010.recop)
	c:RegisterEffect(e2)
	--endphase
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c65011010.ephcon)
	e3:SetTarget(c65011010.ephtg)
	e3:SetOperation(c65011010.ephop)
	c:RegisterEffect(e3)
	--not have bones
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c65011010.notcon)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e5)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e8:SetCondition(c65011010.notcon)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e9)
	local e10=e8:Clone()
	e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e10)
	local e11=e8:Clone()
	e11:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_CANNOT_TRIGGER)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCondition(c65011010.notcon)
	c:RegisterEffect(e12)
	--not have souls
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e13:SetCondition(c65011010.notcon)
	c:RegisterEffect(e13)
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e14:SetCountLimit(1)
	e14:SetCondition(c65011010.notcon)
	e14:SetOperation(c65011010.notsoulop)
	c:RegisterEffect(e14)
	--Check
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetCode(EFFECT_MATERIAL_CHECK)
	e15:SetValue(c65011010.valcheck)
	e15:SetLabelObject(e4)
	c:RegisterEffect(e15)
	local e16=e15:Clone()
	e16:SetLabelObject(e5)
	c:RegisterEffect(e16)
	local e19=e15:Clone()
	e19:SetLabelObject(e8)
	c:RegisterEffect(e19)
	local e20=e15:Clone()
	e20:SetLabelObject(e9)
	c:RegisterEffect(e20)
	local e21=e15:Clone()
	e21:SetLabelObject(e10)
	c:RegisterEffect(e21)
	local e22=e15:Clone()
	e22:SetLabelObject(e11)
	c:RegisterEffect(e22)
	local e23=e15:Clone()
	e23:SetLabelObject(e12)
	c:RegisterEffect(e23)
	local e24=e15:Clone()
	e24:SetValue(c65011010.valcheck2)
	e24:SetLabelObject(e13)
	c:RegisterEffect(e24)
	local e25=e24:Clone()
	e25:SetLabelObject(e14)
	c:RegisterEffect(e25)
	local e26=e24:Clone()
	e26:SetLabelObject(e3)
	c:RegisterEffect(e26)
end

function c65011010.recfilter(c)
	return c:IsSetCard(0xda2) and c:IsAbleToGrave()
end
function c65011010.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65011010.recfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c65011010.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65011010.recfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			Duel.Recover(tp,1500,REASON_EFFECT)
		end
	end
end
function c65011010.ephcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=e:GetLabel()
	return bit.band(flag,0x1)~=0 and c:IsSummonType(SUMMON_TYPE_FUSION)
	and Duel.GetTurnPlayer()==c:GetControler()
end

function c65011010.thfilter(c)
	return c:IsSetCard(0xda2) and c:IsAbleToHand()
end
function c65011010.ephtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65011010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65011010.ephop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65011010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c65011010.notcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=e:GetLabel()
	return bit.band(flag,0x1)==0  or not c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c65011010.notsoulop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65011010)
	local lp=Duel.GetLP(tp)
	if lp<4000 then 
		lp=0 
	else
		lp=lp-4000
	end
	Duel.SetLP(tp,lp)
end
function c65011010.lvfilter(c,fc)
	return c:IsCode(65011003) or c:CheckFusionSubstitute(fc)
end
function c65011010.lvfilter2(c,fc)
	return c:IsCode(65011004) or c:CheckFusionSubstitute(fc)
end
function c65011010.valcheck(e,c)
	local g=c:GetMaterial()
	local flag=0
	if g:GetCount()==2 then
		local lv=0
		local lg1=g:Filter(c65011010.lvfilter,nil,c)
		local lg2=g:Filter(Card.IsRace,nil,RACE_SPELLCASTER)
		if lg1:GetCount()>0 then
			flag=0x1
		end
	end
	e:GetLabelObject():SetLabel(flag)
end
function c65011010.valcheck2(e,c)
	local g=c:GetMaterial()
	local flag=0
	if g:GetCount()==2 then
		local lv=0
		local lg1=g:Filter(c65011010.lvfilter2,nil,c)
		local lg2=g:Filter(Card.IsRace,nil,RACE_SPELLCASTER)
		if lg1:GetCount()>0 then
			flag=0x1
		end
	end
	e:GetLabelObject():SetLabel(flag)
end