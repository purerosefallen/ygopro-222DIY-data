--Evillious ● Daughter of Evil
c77707027.dfc_front_side=77707027+1
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c77707027.initial_effect(c)
	--Summon Allen and Riliane
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77707027,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77707027+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c77707027.sptg)
	e1:SetOperation(c77707027.spop)
	c:RegisterEffect(e1)
	--Give Allen
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77707027,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,77707101+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c77707027.gcon)
	e2:SetTarget(c77707027.gtg)
	e2:SetOperation(c77707027.gop)
	c:RegisterEffect(e2)
	--Give effects, take Allen, send a monster Towers style
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77707027,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,77707201+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c77707027.efcon)
	e3:SetTarget(c77707027.eftg)
	e3:SetOperation(c77707027.efop)
	c:RegisterEffect(e3)
	--Summon Tokens and REVERSE
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77707027,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,77707301+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e4:SetCondition(c77707027.tokcon)
	e4:SetTarget(c77707027.toktg)
	e4:SetOperation(c77707027.tokop)
	c:RegisterEffect(e4)
end
function c77707027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c77707027.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,77708001,0,0x4011,0,1800,3,RACE_FAIRY,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,77708001)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(77708001,1))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UNRELEASABLE_SUM)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e3,true)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e4,true)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CANNOT_ATTACK)
		e6:SetCondition(c77707027.atcon)
		token:RegisterEffect(e6,true)
		local e7=e6:Clone()
		e7:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		token:RegisterEffect(e7,true)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,77708000,0,0x4011,1800,0,3,RACE_FIEND,ATTRIBUTE_LIGTH) then
		local token=Duel.CreateToken(tp,77708000)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(77708000,1))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UNRELEASABLE_SUM)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e3,true)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		token:RegisterEffect(e4,true)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e5,true)
	end
	Duel.SpecialSummonComplete()
	Duel.RegisterFlagEffect(tp,77707027,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c77707027.alfilter(c)
	return c:IsFaceup() and c:IsCode(77708000)
end
function c77707027.atcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c77707027.alfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c77707027.gcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,77707027)~=0 and Duel.GetTurnPlayer()==tp
end
function c77707027.gtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77707027.alfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77707027.alfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c77707027.gop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c77707027.alfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.GetControl(g,1-tp)
	end
	Duel.RegisterFlagEffect(tp,77707101,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c77707027.efcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,77707101)~=0
end
function c77707027.effilter(c,tp)
	return c:IsFaceup()
end
function c77707027.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c77707027.effilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c77707027.alfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,c77707027.effilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c77707027.efop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		--take current mzones
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
		--copy effects
		for card in aux.Next(g) do
			local code=card:GetOriginalCode()
			local cid=tc:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
		end
	end
	if Duel.SelectYesNo(tp,aux.Stringid(77707027,4)) then
		local g1=Duel.SelectTarget(tp,c77707027.alfilter,tp,0,LOCATION_MZONE,1,1,nil)
		if g1:GetCount()>0 then
			Duel.GetControl(g1,tp)
			local g2=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
			if g2:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local sg=g2:Select(1-tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_RULE)
			end
		end
	end
	Duel.RegisterFlagEffect(tp,77707201,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c77707027.tokcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,77707201)~=0 and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c77707027.toktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct=math.min(ft1,ft2)
	if chk==0 then return ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,77708002,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_WIND,POS_FACEUP_ATTACK)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,77708002,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_WIND,POS_FACEUP_ATTACK,1-tp)
		and Senya.IsDFCTransformable(c) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct*2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct*2,0,0)
end
function c77707027.tokop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct=math.min(ft1,ft2)
	if ct>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,77708002,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_WIND,POS_FACEUP_ATTACK)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,77708002,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_WIND,POS_FACEUP_ATTACK,1-tp) then
		for i=1,ct do
			local token=Duel.CreateToken(tp,77708002)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			token=Duel.CreateToken(tp,77708002)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
		Senya.TransformDFCCard(c)
	end
end