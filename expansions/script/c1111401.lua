--灵纹·强制缔结
local m=1111401
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Lines=true
--
function c1111401.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1111401.tg1)
	e1:SetOperation(c1111401.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c1111401.limit2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(800)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c1111401.tg4)
	e4:SetOperation(c1111401.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_EQUIP)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c1111401.op5)
	c:RegisterEffect(e5)
--
end
--
function c1111401.tfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1111401.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1111401.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1111401.tfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1111401.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
--
function c1111401.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--
function c1111401.limit2(e,c)
	local p=e:GetHandler():GetControler()
	return c:GetControler()==p and c:IsType(TYPE_MONSTER)
end
--
function c1111401.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	ec:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ec,1,0,0)
end
--
function c1111401.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if ec and ec:IsRelateToEffect(e) then 
		Duel.SendtoGrave(ec,REASON_RULE)
	end
end
--
function c1111401.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetFirst()~=c then return end
	local tc=c:GetEquipTarget()
	if tc then
		local e5_1=Effect.CreateEffect(c)
		e5_1:SetDescription(aux.Stringid(1111401,0))
		e5_1:SetCategory(CATEGORY_REMOVE)
		e5_1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e5_1:SetType(EFFECT_TYPE_IGNITION)
		e5_1:SetRange(LOCATION_MZONE)
		e5_1:SetLabelObject(c)
		e5_1:SetCountLimit(1,1111401)
		e5_1:SetCondition(c1111401.con5_1)
		e5_1:SetTarget(c1111401.tg5_1)
		e5_1:SetOperation(c1111401.op5_1)
		tc:RegisterEffect(e5_1)
		if e5_1:GetHandler()==nil then return end
	end
end
--
function c1111401.con5_1(e)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else return false
	end
end
--
function c1111401.tg5_1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetLevel()==3 or c:GetLevel()==5 or (c:GetLevel()==6 and not c:IsCode(1110131)) or c:GetLevel()==10 or c:GetRank()==3 end
	local code=c:GetCode()
	if c:GetLevel()>0 then
		local lv=c:GetLevel()
		if lv==3 then
			c1111401.announce_filter={1110001,OPCODE_ISCODE,1110002,OPCODE_ISCODE,OPCODE_OR,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
		elseif lv==5 then
			c1111401.announce_filter={1110111,OPCODE_ISCODE,1110112,OPCODE_ISCODE,1110141,OPCODE_ISCODE,1110142,OPCODE_ISCODE,OPCODE_OR,OPCODE_OR,OPCODE_OR,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
		elseif lv==6 then
			c1111401.announce_filter={1110131,OPCODE_ISCODE,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
		else
			c1111401.announce_filter={1110151,OPCODE_ISCODE,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
		end
	elseif c:GetRank()>0 then
		local rk=c:GetRank()
		if rk==3 then
			c1111401.announce_filter={1110121,OPCODE_ISCODE,1110122,OPCODE_ISCODE,OPCODE_OR,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
		end
	else
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c1111401.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
--
function c1111401.op5_1(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:CopyEffect(ac,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	end
end
--
