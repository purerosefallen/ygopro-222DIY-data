--DJMAX PORTABLE
c26801000.dfc_front_side=26801000
c26801000.dfc_back1_side=26801001
c26801000.dfc_back2_side=26801002
c26801000.dfc_back3_side=26801003
c26801000.dfc_back4_side=26801004
function c26801000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26801000+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c26801000.activate)
	c:RegisterEffect(e1)
end
function c26801000.activate(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,aux.Stringid(26801000,0),aux.Stringid(26801000,1),aux.Stringid(26801000,2),aux.Stringid(26801000,3))
	e:SetLabel(op)
	local c=e:GetHandler()
	if op==0 then
			local tcode=c.dfc_back1_side
			c:SetEntityCode(tcode,true)
			c:ReplaceEffect(tcode,0,0)
		else if op==1 then
			local tcode=c.dfc_back2_side
			c:SetEntityCode(tcode,true)
			c:ReplaceEffect(tcode,0,0)
			else if op==2 then
				local tcode=c.dfc_back3_side
				c:SetEntityCode(tcode,true)
				c:ReplaceEffect(tcode,0,0)
			else
				local tcode=c.dfc_back4_side
				c:SetEntityCode(tcode,true)
				c:ReplaceEffect(tcode,0,0)
			end
		end
	end
end
