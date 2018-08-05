--拟化翼手龙
function c12009032.initial_effect(c)
	--deck bbbbbbbbbb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12009032,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)  
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,12009032)
	e4:SetTarget(c12009032.eqtg)
	e4:SetOperation(c12009032.eqop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)  
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12009032,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,12009132)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c12009032.destg)
	e2:SetOperation(c12009032.desop)
	c:RegisterEffect(e2)   
end
function c12009032.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():GetAttack()>=800 and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,nil,LOCATION_ONFIELD)
end
function c12009032.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() and c:GetAttack()>=800 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-800)
		c:RegisterEffect(e1)
	end
end
function c12009032.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,0,tp,LOCATION_DECK)
end
function c12009032.filter(c,rc)
	return (c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(rc)) or not c:IsType(TYPE_EQUIP) and c:IsType(TYPE_MONSTER)
end
function c12009032.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.GetDecktopGroup(tp,5):Filter(c12009032.filter,nil,c)
	if g:GetCount()>0 and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if not Duel.Equip(tp,tc,c) then return end
		if tc:GetOriginalType()~=TYPE_SPELL+TYPE_EQUIP then
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_EQUIP_LIMIT)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		  e1:SetValue(c12009032.eqlimit)
		  e1:SetLabelObject(c)
		  tc:RegisterEffect(e1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(800)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.ShuffleDeck(tp)
end
function c12009032.eqlimit(e,c)
	return c==e:GetLabelObject()
end
