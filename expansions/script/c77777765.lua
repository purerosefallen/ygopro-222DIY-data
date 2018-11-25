--Orange
local m=77777765
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	Senya.enable_kaguya_check_3L()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),4,7)
	c:EnableReviveLimit()
	Senya.AddSummonMusic(c,m*16+2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()==tp
	end)
	e3:SetTarget(cm.nametg)
	e3:SetOperation(cm.nameop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0x3c0)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return not Duel.CheckEvent(EVENT_CHAINING) and Duel.GetTurnPlayer()~=tp
	end)
	e2:SetCost(Senya.ForbiddenCost(Senya.DescriptionCost()))
	e2:SetTarget(cm.CopySpellNormalTarget)
	e2:SetOperation(Senya.CopyOperation)
	c:RegisterEffect(e2)
	local e1=e2:Clone()
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()~=tp
	end)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetLabel(Senya.order_table_new({e1,e2,e3}))
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c)
	return c:IsSetCard(0xb9c0) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.get_announce(t)
	local rt={t[1],OPCODE_ISCODE}
	for i=2,#t do
		table.insert(rt,t[i])
		table.insert(rt,OPCODE_ISCODE)
		table.insert(rt,OPCODE_OR)
	end
	--table.insert(rt,TYPE_MONSTER)
	--table.insert(rt,OPCODE_ISTYPE)
	--table.insert(rt,OPCODE_AND)
	return rt
end
function cm.nametg(e,tp,eg,ep,ev,re,r,rp,chk)
	local effect_list=Senya.codelist_3L
	local avaliable_list={}
	for i,code in pairs(effect_list) do
		local mt=Senya.LoadMetatable(code)
		if e:GetHandler():GetFlagEffect(code-4000)==0 and mt and mt.effect_operation_3L and not mt.announce_forbidden_3L then table.insert(avaliable_list,code) end  
	end
	if chk==0 then return #avaliable_list>0 end
	cm.announce_filter=cm.get_announce(avaliable_list)
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(cm.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function cm.nameop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Senya.GainEffect_3L(c,ac)
	end
end
function cm.GetHandEffect(c)
	Senya.sin_cache=Senya.sin_cache or {}
	local code=c:GetOriginalCode()
	if Senya.sin_cache[code] then return Senya.sin_cache[code] end
	local eset={}
	local temp=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,f)
		if (e:GetRange()&LOCATION_HAND)>0 and e:IsHasType(0x7e0) then
			table.insert(eset,e:Clone())
		end
		return temp(tc,e,f)
	end
	Senya.IgnoreActionCheck(Duel.CreateToken,c:GetControler(),code)
	Card.RegisterEffect=temp
	Senya.sin_cache[code]=eset
	return eset
end
function cm.CheckHandEffect(c,sec,e,tp,eg,ep,ev,re,r,rp)
	local eset=cm.GetHandEffect(c)
	if #eset==0 then return false end
	local ee,teg,tep,tev,tre,tr,trp
	for _,te in ipairs(eset) do
		local tres=false
		local code=te:GetCode()
		if code~=EVENT_CHAINING and code~=EVENT_FREE_CHAIN then
			tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(code,true)
		elseif sec or code==EVENT_FREE_CHAIN then
			tres=true
			teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
		end
		if tres then
			local con=te:GetCondition()
			local tg=te:GetTarget()
			if Senya.ProtectedRun(con,e,tp,teg,tep,tev,tre,tr,trp) and Senya.ProtectedRun(tg,e,tp,teg,tep,tev,tre,tr,trp,0) then
				ee=te
				break
			end
		end
	end
	if ee then
		return true,ee,teg,tep,tev,tre,tr,trp
	else
		return false
	end
end
function cm.CopySpellNormalFilter(c,sec,e,tp,eg,ep,ev,re,r,rp)
	local te=cm.GetHandEffect(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa9c0)
		and c:IsAbleToGraveAsCost() and cm.CheckHandEffect(c,sec,e,tp,eg,ep,ev,re,r,rp)
end
function cm.CopySpellNormalTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and Senya.ProtectedRun(tg,e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	local og=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local sec=(e:GetCode()==EVENT_CHAINING)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return og:IsExists(cm.CopySpellNormalFilter,1,nil,sec,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=og:FilterSelect(tp,cm.CopySpellNormalFilter,1,1,nil,sec,e,tp,eg,ep,ev,re,r,rp)
	local _,te,ceg,cep,cev,cre,cr,crp=cm.CheckHandEffect(g:GetFirst(),sec,e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	local tg=te:GetTarget()
	Senya.ProtectedRun(tg,e,tp,ceg,cep,cev,cre,cr,crp,1)
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	local ex=Effect.GlobalEffect()
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_CHAIN_END)
	ex:SetLabelObject(e)
	ex:SetOperation(function(e)
		e:GetLabelObject():SetLabel(0)
		ex:Reset()
	end)
	Duel.RegisterEffect(ex,tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(37564565) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local eset=Senya.order_table[e:GetLabel()]
		for _,te in ipairs(eset) do
			local te_=te:Clone()
			te_:SetOwner(tc)
			te_:SetReset(0x1fe1000)
			tc:RegisterEffect(te_,true)
		end
		Duel.SpecialSummonComplete()
	end
end